import 'dart:async';

import 'package:smart_xdrip/application/subject/active_subject_service.dart';
import 'package:smart_xdrip/data/local/glucose_database.dart';

import '../domain/component_health.dart';
import '../domain/status_report.dart';
import '../domain/status_timeline_point.dart';
import 'checking/models/status_check_component_phase.dart';
import 'checking/models/status_check_session_phase.dart';
import 'checking/models/status_check_session_state.dart';
import 'checking/status_check_session_runner.dart';
import 'history/status_history_recorder.dart';
import 'probe_scenario/engine/status_probe_scenario_engine.dart';
import 'shared/status_check_shared_context.dart';
import 'shared/status_check_shared_context_builder.dart';
import 'shared/status_report_source_evidence_builder.dart';
import 'status_monitor_target_resolver.dart';
import 'status_report_builder.dart';

class StatusMonitorCheckService {
  final GlucoseDatabase database;
  final ActiveSubjectService activeSubjectService;
  final StatusMonitorTargetResolver targetResolver;
  final StatusCheckSessionRunner runner;
  final StatusHistoryRecorder historyRecorder;
  final StatusReportBuilder reportBuilder;
  final StatusReportSourceEvidenceBuilder sourceEvidenceBuilder;
  final StatusProbeScenarioEngine? probeScenarioEngine;
  final DateTime Function() now;

  const StatusMonitorCheckService({
    required this.database,
    required this.activeSubjectService,
    required this.targetResolver,
    required this.runner,
    required this.historyRecorder,
    this.reportBuilder = const StatusReportBuilder(),
    this.sourceEvidenceBuilder = const StatusReportSourceEvidenceBuilder(),
    this.probeScenarioEngine,
    DateTime Function()? now,
  }) : now = now ?? DateTime.now;

  String get currentSubjectId => activeSubjectService.current.id;

  Stream<StatusMonitorCheckUpdate> startFreshSession() async* {
    final current = now();
    final shared = await StatusCheckSharedContextBuilder(
      database: database,
      activeSubjectService: activeSubjectService,
      targetResolver: targetResolver,
      probeScenarioEngine: probeScenarioEngine,
    ).build(now: current);

    await for (final state in runner.run(
      subjectId: shared.subjectId,
      sharedContext: shared,
    )) {
      if (state.phase == StatusCheckSessionPhase.completed) {
        final report = await _buildFinalReport(state, shared);
        yield StatusMonitorCheckUpdate(state: state, report: report);
      } else {
        yield StatusMonitorCheckUpdate(state: state);
      }
    }
  }

  Future<StatusReport> _buildFinalReport(
    StatusCheckSessionState state,
    StatusCheckSharedContext sharedContext,
  ) async {
    final evidenceWithTimeline = sourceEvidenceBuilder.build(sharedContext);
    final history = await historyRecorder.latest(
      subjectId: state.subjectId,
      sourceTargetId: evidenceWithTimeline.primarySourceTargetId,
      sourceKind: evidenceWithTimeline.primarySourceKind,
      now: now(),
    );
    final components = state.components
        .where((component) =>
            component.phase == StatusCheckComponentPhase.completed &&
            component.health != null)
        .map((component) => component.health!)
        .toList(growable: false);
    final report = reportBuilder.buildFromComponents(
      now: now(),
      evidence: evidenceWithTimeline,
      history: history,
      components: components,
    );
    final inserted = await historyRecorder.record(report);
    if (inserted.isEmpty) return report;
    return StatusReport(
      subjectId: report.subjectId,
      sourceTargetId: report.sourceTargetId,
      sourceKind: report.sourceKind,
      sourceLabel: report.sourceLabel,
      generatedAt: report.generatedAt,
      summary: report.summary,
      components: _attachHistory(report.components, [...history, ...inserted]),
      recentEvents: [...history, ...inserted],
      capabilities: report.capabilities,
      hasConfiguredSource: report.hasConfiguredSource,
      emptyReason: report.emptyReason,
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

class StatusMonitorCheckUpdate {
  final StatusCheckSessionState state;
  final StatusReport? report;

  const StatusMonitorCheckUpdate({
    required this.state,
    this.report,
  });
}
