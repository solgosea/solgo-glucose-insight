import '../../data/sqlite/status_monitor_repository.dart';
import '../../domain/history/status_component_history_sample.dart';
import '../../domain/history/status_history_query.dart';
import '../../domain/history/status_history_scope.dart';
import '../../domain/history/status_history_sample_source.dart';
import '../../domain/history/status_history_window.dart';
import '../../domain/status_report.dart';
import '../../domain/status_timeline_point.dart';
import 'status_history_query_builder.dart';

class StatusHistoryRecorder {
  final StatusMonitorRepository repository;
  final StatusHistoryQueryBuilder queryBuilder;

  const StatusHistoryRecorder({
    required this.repository,
    this.queryBuilder = const StatusHistoryQueryBuilder(),
  });

  Future<List<StatusTimelinePoint>> latest({
    required String subjectId,
    String? sourceTargetId,
    String? sourceKind,
    DateTime? now,
    int limit = 21,
  }) {
    final scopedSourceTargetId = sourceKind == null && sourceTargetId == null
        ? null
        : queryBuilder.scopeTargetId(
            sourceTargetId: sourceTargetId,
            sourceKind: sourceKind ?? 'unknown',
          );
    final current = now;
    if (current != null) {
      return repository.queryHistory(
        StatusHistoryQuery(
          scope: StatusHistoryScope(
            subjectId: subjectId,
            sourceTargetId: scopedSourceTargetId,
          ),
          window: StatusHistoryWindow.lastSevenDays(current),
        ),
      );
    }
    return repository.latestHistory(
      subjectId: subjectId,
      sourceTargetId: scopedSourceTargetId,
      limit: limit,
    );
  }

  Future<List<StatusTimelinePoint>> record(StatusReport report) async {
    await repository.saveReport(report);
    final source = StatusHistorySampleSource(
      targetId: queryBuilder.scopeTargetId(
        sourceTargetId: report.sourceTargetId,
        sourceKind: report.sourceKind,
      ),
      kind: report.sourceKind,
      label: report.sourceLabel,
    );
    final inserted = <StatusTimelinePoint>[];
    for (final component in report.components) {
      final sample = StatusComponentHistorySample(
        at: report.generatedAt,
        component: component.kind,
        level: component.level,
        score: component.score?.value,
        confidence: component.score?.confidence,
        summary: component.summary,
        source: source,
      );
      await repository.insertHistorySample(
        subjectId: report.subjectId,
        sample: sample,
      );
      inserted.add(
        StatusTimelinePoint(
          at: sample.at,
          component: sample.component,
          level: sample.level,
          summary: sample.summary,
        ),
      );
    }
    return inserted;
  }
}
