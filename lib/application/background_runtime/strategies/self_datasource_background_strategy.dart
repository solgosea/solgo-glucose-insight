import '../../sync_strategy/data_source_sync_strategy_coordinator.dart';
import '../background_runtime_context.dart';
import '../background_runtime_reason.dart';
import '../background_runtime_start_strategy.dart';

class SelfDatasourceBackgroundStrategy
    implements BackgroundRuntimeStartStrategy {
  final DataSourceSyncStrategyCoordinator strategyCoordinator;

  const SelfDatasourceBackgroundStrategy({
    this.strategyCoordinator = const DataSourceSyncStrategyCoordinator(),
  });

  @override
  BackgroundRuntimeReason get reason =>
      BackgroundRuntimeReason.selfDatasourceEnabled;

  @override
  Future<bool> shouldStart(BackgroundRuntimeContext context) async {
    return strategyCoordinator.hasEnabledStrategy(context.settings);
  }
}
