import '../../data/sqlite/status_monitor_repository.dart';
import '../../domain/component_health.dart';
import '../../domain/history/status_component_history_result.dart';
import '../../domain/status_report.dart';
import 'engine/status_history_engine.dart';
import 'status_history_query_builder.dart';

class StatusHistoryService {
  final StatusMonitorRepository repository;
  final StatusHistoryQueryBuilder queryBuilder;
  final StatusHistoryEngine historyEngine;

  const StatusHistoryService({
    required this.repository,
    this.queryBuilder = const StatusHistoryQueryBuilder(),
    this.historyEngine = const StatusHistoryEngine(),
  });

  Future<StatusComponentHistoryResult> loadComponentForReport({
    required StatusReport report,
    required ComponentHealth component,
    required DateTime now,
  }) async {
    final query = queryBuilder.fromReport(report, now);
    final samples = await repository.queryComponentHistorySamples(
      query,
      component: component.kind,
    );
    return historyEngine.calculateComponent(
      component: component,
      samples: samples,
      now: now,
    );
  }
}
