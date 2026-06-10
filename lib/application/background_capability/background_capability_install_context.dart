import '../../application/background_runtime/background_runtime_strategy_registry.dart';
import '../../application/background_sync/background_sync_post_task_registry.dart';
import '../../application/sync_target/glucose_sync_target_registry.dart';
import '../../data/local/glucose_database.dart';

class BackgroundCapabilityInstallContext {
  final GlucoseDatabase database;
  final GlucoseSyncTargetRegistry syncTargetRegistry;
  final BackgroundSyncPostTaskRegistry postTaskRegistry;
  final BackgroundRuntimeStrategyRegistry? runtimeStrategyRegistry;

  const BackgroundCapabilityInstallContext({
    required this.database,
    required this.syncTargetRegistry,
    required this.postTaskRegistry,
    this.runtimeStrategyRegistry,
  });
}
