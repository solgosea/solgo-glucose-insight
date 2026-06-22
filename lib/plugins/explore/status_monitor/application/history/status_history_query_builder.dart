import '../../domain/history/status_history_query.dart';
import '../../domain/history/status_history_scope.dart';
import '../../domain/history/status_history_window.dart';
import '../../domain/status_report.dart';

class StatusHistoryQueryBuilder {
  const StatusHistoryQueryBuilder();

  StatusHistoryQuery fromReport(StatusReport report, DateTime now) {
    return StatusHistoryQuery(
      scope: StatusHistoryScope(
        subjectId: report.subjectId,
        sourceTargetId: scopeTargetId(
          sourceTargetId: report.sourceTargetId,
          sourceKind: report.sourceKind,
        ),
      ),
      window: StatusHistoryWindow.lastSevenDays(now),
    );
  }

  String scopeTargetId({
    required String? sourceTargetId,
    required String sourceKind,
  }) {
    final target = sourceTargetId?.trim();
    if (target != null && target.isNotEmpty) return target;
    return sourceKind;
  }
}
