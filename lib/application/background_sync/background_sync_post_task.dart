import '../../domain/data_source_runtime/data_source_runtime_snapshot.dart';
import '../../domain/entities/app_settings.dart';

class BackgroundSyncPostTaskContext {
  final AppSettings settings;
  final List<DataSourceRuntimeSnapshot> runtimeSnapshots;
  final bool syncSucceeded;
  final DateTime checkedAt;

  const BackgroundSyncPostTaskContext({
    required this.settings,
    required this.runtimeSnapshots,
    required this.syncSucceeded,
    required this.checkedAt,
  });
}

abstract class BackgroundSyncPostTask {
  Future<void> run(BackgroundSyncPostTaskContext context);
}
