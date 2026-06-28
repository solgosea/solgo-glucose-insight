import 'package:smart_xdrip/application/subject/active_subject_service.dart';
import 'package:smart_xdrip/data/local/glucose_database.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';

import '../domain/component_health.dart';
import '../domain/status_report.dart';
import '../domain/status_timeline_point.dart';
import 'checking/models/status_check_component_phase.dart';
import 'checking/models/status_check_session_phase.dart';
import 'checking/status_check_session_runner.dart';
import 'history/status_history_recorder.dart';
import 'probe_scenario/engine/status_probe_scenario_engine.dart';
import 'shared/status_check_shared_context.dart';
import 'shared/status_check_shared_context_builder.dart';
import 'shared/status_report_source_evidence_builder.dart';
import 'status_report_builder.dart';
import 'status_monitor_target_resolver.dart';

class StatusMonitorService {
  final GlucoseDatabase database;
  final ActiveSubjectService activeSubjectService;
  final AppSettings Function() settingsProvider;
  final StatusMonitorTargetResolver targetResolver;
  final StatusCheckSessionRunner runner;
  final StatusReportBuilder reportBuilder;
  final StatusReportSourceEvidenceBuilder sourceEvidenceBuilder;
  final StatusHistoryRecorder historyRecorder;
  final StatusProbeScenarioEngine? probeScenarioEngine;
  final DateTime Function() now;

  const StatusMonitorService({
    required this.database,
    required this.activeSubjectService,
    required this.settingsProvider,
    required this.targetResolver,
    required this.runner,
    required this.historyRecorder,
    this.probeScenarioEngine,
    this.reportBuilder = const StatusReportBuilder(),
    this.sourceEvidenceBuilder = const StatusReportSourceEvidenceBuilder(),
    DateTime Function()? now,
  }) : now = now ?? DateTime.now;

  String get currentSubjectId => activeSubjectService.current.id;

  Future<StatusReport> evaluate() async {
    final current = now();
    final shared = await StatusCheckSharedContextBuilder(
      database: database,
      activeSubjectService: activeSubjectService,
      targetResolver: targetResolver,
      probeScenarioEngine: probeScenarioEngine,
    ).build(now: current);
    final evidenceWithTimeline = sourceEvidenceBuilder.build(shared);
    final history = await historyRecorder.latest(
      subjectId: shared.subjectId,
      sourceTargetId: evidenceWithTimeline.primarySourceTargetId,
      sourceKind: evidenceWithTimeline.primarySourceKind,
      now: current,
    );
    final components = await _runComponents(shared);
    final report = reportBuilder.buildFromComponents(
      now: current,
      evidence: evidenceWithTimeline,
      history: history,
      components: components,
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

  Future<List<ComponentHealth>> _runComponents(
    StatusCheckSharedContext shared,
  ) async {
    await for (final state in runner.run(
      subjectId: shared.subjectId,
      sharedContext: shared,
    )) {
      if (state.phase != StatusCheckSessionPhase.completed) continue;
      return state.components
          .where((component) =>
              component.phase == StatusCheckComponentPhase.completed &&
              component.health != null)
          .map((component) => component.health!)
          .toList(growable: false);
    }
    return const [];
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
