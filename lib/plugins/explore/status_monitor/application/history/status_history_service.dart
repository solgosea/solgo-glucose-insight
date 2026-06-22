import '../../data/sqlite/status_monitor_repository.dart';
import '../../domain/history/status_history_result.dart';
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

  Future<StatusHistoryResult> loadForReport({
    required StatusReport report,
    required DateTime now,
  }) async {
    final query = queryBuilder.fromReport(report, now);
    final samples = await repository.queryHistorySamples(query);
    return historyEngine.calculate(
      query: query,
      components: report.components,
      samples: samples,
      now: now,
    );
  }
}
