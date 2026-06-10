import 'package:smart_xdrip/application/sync/glucose_sync_result.dart';
import 'package:smart_xdrip/application/sync/glucose_sync_coordinator.dart';
import 'package:smart_xdrip/application/sync_target/glucose_sync_target_registry.dart';
import 'package:smart_xdrip/application/sync_target/glucose_sync_target_runner.dart';
import 'package:smart_xdrip/application/sync_target/providers/self_data_source_sync_target_provider.dart';
import 'package:smart_xdrip/data/local/glucose_database.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';

import 'glucose_source_selection_policy.dart';
import 'glucose_source_sync_result.dart';

class GlucoseSourceSyncOrchestrator {
  final GlucoseDatabase database;
  final GlucoseSourceSelectionPolicy sourceSelectionPolicy;
  final GlucoseSyncCoordinator syncCoordinator;
  final GlucoseSyncTargetRegistry targetRegistry;

  GlucoseSourceSyncOrchestrator({
    required this.database,
    GlucoseSourceSelectionPolicy? sourceSelectionPolicy,
    GlucoseSyncCoordinator? syncCoordinator,
    GlucoseSyncTargetRegistry? targetRegistry,
  }) : sourceSelectionPolicy =
           sourceSelectionPolicy ?? const GlucoseSourceSelectionPolicy(),
       syncCoordinator =
           syncCoordinator ?? GlucoseSyncCoordinator(database: database),
       targetRegistry =
           targetRegistry ??
           GlucoseSyncTargetRegistry(
             providers: const [SelfDataSourceSyncTargetProvider()],
           );

  Future<GlucoseSourceSyncResult> syncConfiguredSources({
    required AppSettings settings,
  }) async {
    final targets = await targetRegistry.targetsFor(settings);
    final results = <GlucoseSyncResult>[];
    final runner = GlucoseSyncTargetRunner(syncCoordinator: syncCoordinator);
    for (final target in targets) {
      results.add(await runner.run(target: target, settings: settings));
    }
    return GlucoseSourceSyncResult(sourceResults: results);
  }
}
