import 'package:smart_xdrip/application/sync/glucose_sync_coordinator.dart';
import 'package:smart_xdrip/application/sync/glucose_sync_plan.dart';
import 'package:smart_xdrip/application/sync_scheduler/glucose_sync_task_priority.dart';
import 'package:smart_xdrip/application/sync_scheduler/glucose_sync_task_reason.dart';
import 'package:smart_xdrip/application/sync_scheduler/glucose_sync_task_scheduler.dart';
import 'package:smart_xdrip/application/sync_target/glucose_sync_target_registry.dart';
import 'package:smart_xdrip/application/sync_target/glucose_sync_target_runner.dart';
import 'package:smart_xdrip/application/sync_target/providers/self_data_source_sync_target_provider.dart';
import 'package:smart_xdrip/data/local/glucose_database.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/sync_target/glucose_sync_target.dart';

import 'glucose_source_selection_policy.dart';
import 'glucose_source_sync_result.dart';

class GlucoseSourceSyncOrchestrator {
  final GlucoseDatabase database;
  final GlucoseSourceSelectionPolicy sourceSelectionPolicy;
  late final GlucoseSyncCoordinator syncCoordinator;
  late final GlucoseSyncTargetRegistry targetRegistry;
  late final GlucoseSyncTaskScheduler scheduler;

  GlucoseSourceSyncOrchestrator({
    required this.database,
    GlucoseSourceSelectionPolicy? sourceSelectionPolicy,
    GlucoseSyncCoordinator? syncCoordinator,
    GlucoseSyncTargetRegistry? targetRegistry,
    GlucoseSyncTaskScheduler? scheduler,
  }) : sourceSelectionPolicy =
            sourceSelectionPolicy ?? const GlucoseSourceSelectionPolicy() {
    this.syncCoordinator =
        syncCoordinator ?? GlucoseSyncCoordinator(database: database);
    this.targetRegistry = targetRegistry ??
        GlucoseSyncTargetRegistry(
          providers: const [SelfDataSourceSyncTargetProvider()],
        );
    this.scheduler = scheduler ??
        GlucoseSyncTaskScheduler(
          runner: GlucoseSyncTargetRunner(
            syncCoordinator: this.syncCoordinator,
          ),
        );
  }

  Future<GlucoseSourceSyncResult> syncConfiguredSources({
    required AppSettings settings,
  }) async {
    final targets = await targetRegistry.targetsFor(settings);
    scheduler.enqueueAll(
      targets,
      priority: GlucoseSyncTaskPriority.foreground,
      reason: GlucoseSyncTaskReason.foreground,
    );
    final scheduled = await scheduler.drain(settings: settings);
    return GlucoseSourceSyncResult(
      sourceResults: scheduled.results,
    );
  }

  Future<GlucoseSourceSyncResult> syncTarget({
    required AppSettings settings,
    required String targetId,
    GlucoseSyncTaskPriority priority = GlucoseSyncTaskPriority.manual,
    GlucoseSyncTaskReason reason = GlucoseSyncTaskReason.manual,
    GlucoseSyncPlan? explicitPlan,
  }) async {
    final targets = await targetRegistry.targetsFor(settings);
    GlucoseSyncTarget? target;
    for (final candidate in targets) {
      if (candidate.targetId == targetId) {
        target = candidate;
        break;
      }
    }
    if (target == null) {
      return const GlucoseSourceSyncResult(sourceResults: []);
    }
    scheduler.enqueueTarget(
      target,
      priority: priority,
      reason: reason,
      explicitPlan: explicitPlan,
    );
    final scheduled = await scheduler.drain(settings: settings);
    return GlucoseSourceSyncResult(sourceResults: scheduled.results);
  }
}
