import 'package:smart_xdrip/application/subject/active_subject_service.dart';
import 'package:smart_xdrip/data/local/glucose_database.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';

import '../domain/component_health.dart';
import '../domain/evidence/status_evidence_bundle.dart';
import '../domain/status_report.dart';
import '../domain/status_timeline_point.dart';
import 'probes/status_probe_orchestrator.dart';
import 'probes/status_probe_plan.dart';
import 'history/status_history_recorder.dart';
import 'status_report_builder.dart';
import 'status_monitor_target_resolver.dart';
import '../data/sqlite/status_monitor_probe_repository.dart';

class StatusMonitorService {
  final GlucoseDatabase database;
  final ActiveSubjectService activeSubjectService;
  final AppSettings Function() settingsProvider;
  final StatusMonitorTargetResolver targetResolver;
  final StatusReportBuilder reportBuilder;
  final StatusHistoryRecorder historyRecorder;
  final StatusMonitorProbeRepository? probeRepository;
  final StatusProbeOrchestrator? probeOrchestrator;
  final DateTime Function() now;

  const StatusMonitorService({
    required this.database,
    required this.activeSubjectService,
    required this.settingsProvider,
    required this.targetResolver,
    required this.historyRecorder,
    this.reportBuilder = const StatusReportBuilder(),
    this.probeRepository,
    this.probeOrchestrator,
    DateTime Function()? now,
  }) : now = now ?? DateTime.now;

  String get currentSubjectId => activeSubjectService.current.id;

  Future<StatusReport> evaluate() async {
    final current = now();
    final subject = activeSubjectService.snapshot().subject;
    final evidence =
        await (probeOrchestrator ?? StatusProbeOrchestrator(database: database))
            .run(
      StatusProbePlan(
        subjectId: subject.id,
        xdripLocal: targetResolver.resolveSelfXdripLocal(subject),
        nightscout: targetResolver.resolveEnabledNightscout(subject),
      ),
      now: current,
    );
    final evidenceWithTimeline = await _attachNightscoutProbeTimeline(evidence);
    final history = await historyRecorder.latest(
      subjectId: subject.id,
      sourceTargetId: evidenceWithTimeline.primarySourceTargetId,
      sourceKind: evidenceWithTimeline.primarySourceKind,
      now: current,
    );
    final report = await reportBuilder.build(
      now: current,
      evidence: evidenceWithTimeline,
      history: history,
    );
    final inserted = await historyRecorder.record(report);
    if (inserted.isEmpty) return report;
    final combinedHistory = [...history, ...inserted];
    return StatusReport(
      subjectId: report.subjectId,
      sourceTargetId: report.sourceTargetId,
      sourceKind: report.sourceKind,
      sourceLabel: report.sourceLabel,
      generatedAt: report.generatedAt,
      summary: report.summary,
      components: _attachHistory(report.components, combinedHistory),
      recentEvents: combinedHistory,
      capabilities: report.capabilities,
      hasConfiguredSource: report.hasConfiguredSource,
      emptyReason: report.emptyReason,
    );
  }

  Future<StatusEvidenceBundle> _attachNightscoutProbeTimeline(
    StatusEvidenceBundle evidence,
  ) async {
    final repository = probeRepository;
    final nightscout = evidence.nightscoutEvidence;
    if (repository == null || nightscout.endpointProbes.isEmpty) {
      return evidence;
    }
    await repository.saveSamples(
      subjectId: evidence.subjectId,
      sourceTargetId: nightscout.sourceTargetId,
      probes: nightscout.endpointProbes,
    );
    String? statusEndpoint;
    for (final probe in nightscout.endpointProbes) {
      if (probe.endpoint.contains('status.json')) {
        statusEndpoint = probe.endpoint;
        break;
      }
    }
    if (statusEndpoint == null) return evidence;
    final timeline = await repository.latestResponsePoints(
      subjectId: evidence.subjectId,
      endpoint: statusEndpoint,
      limit: 30,
    );
    if (timeline.isEmpty) return evidence;
    return evidence.copyWith(
      nightscoutEvidence: nightscout.copyWith(responseTimeline: timeline),
    );
  }

  List<ComponentHealth> _attachHistory(
    List<ComponentHealth> components,
    List<StatusTimelinePoint> history,
  ) {
    return components
        .map(
          (component) => ComponentHealth(
            kind: component.kind,
            level: component.level,
            title: component.title,
            role: component.role,
            takeaway: component.takeaway,
            summary: component.summary,
            metrics: component.metrics,
            directions: component.directions,
            history: history
                .where((point) => point.component == component.kind)
                .toList(growable: false),
            score: component.score,
            detailData: component.detailData,
          ),
        )
        .toList(growable: false);
  }
}
