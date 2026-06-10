import '../../domain/entities/app_settings.dart';
import '../sync/glucose_sync_result.dart';
import 'glucose_sync_target_registry.dart';
import 'glucose_sync_target_runner.dart';

class GlucoseSyncTargetCoordinator {
  final GlucoseSyncTargetRegistry registry;
  final GlucoseSyncTargetRunner runner;

  const GlucoseSyncTargetCoordinator({
    required this.registry,
    required this.runner,
  });

  Future<List<GlucoseSyncResult>> syncAll(AppSettings settings) async {
    final targets = await registry.targetsFor(settings);
    final results = <GlucoseSyncResult>[];
    for (final target in targets) {
      results.add(await runner.run(target: target, settings: settings));
    }
    return results;
  }
}
