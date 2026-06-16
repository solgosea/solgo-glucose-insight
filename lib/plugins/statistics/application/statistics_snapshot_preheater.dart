import '../mappers/statistics_view_model_mapper.dart';
import '../domain/statistics_analysis_window_id.dart';
import '../runtime/statistics_runtime_cache.dart';
import 'statistics_host_services.dart';
import 'statistics_period_query.dart';

class StatisticsSnapshotPreheater {
  final StatisticsHostServices hostServices;
  final StatisticsViewModelMapper mapper;
  final DateTime Function() now;

  const StatisticsSnapshotPreheater({
    required this.hostServices,
    this.mapper = const StatisticsViewModelMapper(),
    DateTime Function()? now,
  }) : now = now ?? DateTime.now;

  Future<StatisticsRuntimeSnapshot> preheat({
    required StatisticsAnalysisWindowId windowId,
  }) async {
    final facade = hostServices.facadeProvider();
    final query = StatisticsPeriodQuery(
      subjectId: facade.activeSubject.id,
      windowId: windowId,
    );
    return StatisticsRuntimeSnapshot(
      query: query,
      viewModel: mapper.map(
        facade: facade,
        selectedWindowId: windowId,
      ),
      updatedAt: now(),
    );
  }
}
