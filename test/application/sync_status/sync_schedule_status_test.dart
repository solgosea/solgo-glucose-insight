import 'package:flutter_test/flutter_test.dart';
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

    expect(viewModel.label, contains('3 min ago'));
    expect(viewModel.countdownLabel, contains('Est. next'));
    expect(viewModel.nextSyncAt, isNotNull);
    expect(viewModel.scheduleEstimated, isTrue);
    expect(viewModel.scheduleActive, isTrue);
  });
}
