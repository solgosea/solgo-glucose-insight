import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/platform_runtime/sync_runtime_capability.dart';
import 'package:smart_xdrip/application/sync_runtime/sync_runtime_mode.dart';
import 'package:smart_xdrip/application/sync_runtime/sync_runtime_status.dart';
import 'package:smart_xdrip/domain/sync_status/sync_schedule_mode.dart';
import 'package:smart_xdrip/domain/sync_status/sync_schedule_snapshot.dart';
import 'package:smart_xdrip/domain/sync_status/sync_status_level.dart';
import 'package:smart_xdrip/domain/sync_status/sync_status_snapshot.dart';
import 'package:smart_xdrip/presentation/common/sync_status/sync_status_view_model_mapper.dart';

void main() {
  test('sync status view model exposes next schedule countdown', () {
    final now = DateTime.now();
    final viewModel = const SyncStatusViewModelMapper().map(
      SyncStatusSnapshot(
        sourceLabel: 'Nightscout API',
        level: SyncStatusLevel.fresh,
        active: true,
        lastSuccessAt: now.subtract(const Duration(minutes: 3)),
        schedule: SyncScheduleSnapshot(
          reportedAt: now,
          mode: SyncScheduleMode.background,
          nextInterval: const Duration(minutes: 2),
          nextSyncAt: now.add(const Duration(minutes: 2)),
          reason: 'Background normal polling',
          estimated: true,
        ),
      ),
    );

    expect(viewModel.label, 'Nightscout API - Synced');
    expect(viewModel.statusLabel, 'Synced');
    expect(viewModel.timeLabel, contains('3 min ago'));
    expect(viewModel.countdownLabel, contains('Est. next'));
    expect(viewModel.scheduleLabel, contains('Est. next'));
    expect(viewModel.nextSyncAt, isNotNull);
    expect(viewModel.scheduleEstimated, isTrue);
    expect(viewModel.scheduleActive, isTrue);
  });

  test('sync status view model exposes only user-facing new count', () {
    final viewModel = const SyncStatusViewModelMapper().map(
      SyncStatusSnapshot(
        sourceLabel: 'Nightscout API',
        level: SyncStatusLevel.fresh,
        active: true,
        lastSuccessAt: DateTime.now(),
        lastFetchedCount: 12,
        lastStoredCount: 0,
      ),
    );

    expect(viewModel.syncCountLabel, '0 new');
    expect(viewModel.syncCountLabel, isNot(contains('checked')));
    expect(viewModel.semanticLabel, isNot(contains('checked')));
  });

  test('sync status view model hides inactive sync from home header', () {
    final viewModel = const SyncStatusViewModelMapper().map(
      const SyncStatusSnapshot(
        sourceLabel: 'No data source',
        level: SyncStatusLevel.inactive,
        active: false,
      ),
      runtimeStatus: const SyncRuntimeStatus(
        mode: SyncRuntimeMode.continuousBackground,
        capability: SyncRuntimeCapability.android(),
        continuousBackgroundActive: false,
        message: 'Continuous background sync is available but idle.',
      ),
    );

    expect(viewModel.display, isFalse);
    expect(viewModel.runtimeLimitationText, isEmpty);
  });

  test('sync status view model suppresses available-but-idle runtime copy', () {
    final viewModel = const SyncStatusViewModelMapper().map(
      SyncStatusSnapshot(
        sourceLabel: 'Nightscout API',
        level: SyncStatusLevel.waitingFirstSync,
        active: true,
        schedule: SyncScheduleSnapshot(
          reportedAt: DateTime(2026, 6, 11),
          mode: SyncScheduleMode.waiting,
        ),
      ),
      runtimeStatus: const SyncRuntimeStatus(
        mode: SyncRuntimeMode.continuousBackground,
        capability: SyncRuntimeCapability.android(),
        continuousBackgroundActive: false,
        message: 'Continuous background sync is available but idle.',
      ),
    );

    expect(viewModel.display, isTrue);
    expect(viewModel.runtimeLimitationText, isEmpty);
  });
}
