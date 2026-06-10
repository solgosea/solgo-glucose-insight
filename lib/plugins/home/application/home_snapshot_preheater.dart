import '../../../application/analysis/analysis_facade.dart';
import '../../../presentation/common/sync_status/sync_status_view_model_mapper.dart';
import '../mappers/home_view_model_mapper.dart';
import '../models/home_chart_range.dart';
import '../runtime/home_runtime_cache.dart';
import 'home_host_services.dart';

class HomeSnapshotPreheater {
  final HomeHostServices hostServices;
  final AnalysisFacade Function() facadeProvider;
  final HomeViewModelMapper mapper;
  final SyncStatusViewModelMapper syncStatusMapper;
  final DateTime Function() now;

  const HomeSnapshotPreheater({
    required this.hostServices,
    this.facadeProvider = AnalysisFacade.current,
    this.mapper = const HomeViewModelMapper(),
    this.syncStatusMapper = const SyncStatusViewModelMapper(),
    DateTime Function()? now,
  }) : now = now ?? DateTime.now;

  Future<HomeRuntimeSnapshot> preheat({required HomeChartRange range}) async {
    final facade = facadeProvider();
    final syncStatus = await hostServices.syncStatusSnapshot();
    final viewModel = mapper.map(
      facade: facade,
      selectedRange: range,
      syncStatus: syncStatusMapper.map(syncStatus),
    );
    return HomeRuntimeSnapshot(
      subjectId: facade.activeSubject.id,
      range: range,
      viewModel: viewModel,
      updatedAt: now(),
    );
  }
}
