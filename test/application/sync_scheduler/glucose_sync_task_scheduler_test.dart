import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/sync/glucose_sync_coordinator.dart';
import 'package:smart_xdrip/application/sync/glucose_sync_plan.dart';
import 'package:smart_xdrip/application/sync/glucose_sync_result.dart';
import 'package:smart_xdrip/application/sync_scheduler/glucose_sync_task_priority.dart';
import 'package:smart_xdrip/application/sync_scheduler/glucose_sync_task_reason.dart';
import 'package:smart_xdrip/application/sync_scheduler/glucose_sync_task_scheduler.dart';
import 'package:smart_xdrip/application/sync_scheduler/limiters/glucose_sync_persistence_limiter.dart';
import 'package:smart_xdrip/application/sync_scheduler/worker_pool/glucose_sync_worker_pool_config.dart';
import 'package:smart_xdrip/application/sync_target/glucose_sync_target_runner.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/domain/sources/i_glucose_source.dart';
import 'package:smart_xdrip/domain/sync_target/glucose_sync_target.dart';
import 'package:smart_xdrip/domain/sync_target/glucose_sync_target_kind.dart';
import 'package:smart_xdrip/domain/sync_target/glucose_sync_target_source_metadata.dart';

void main() {
  test('scheduler dedupes target tasks and runs the highest priority request',
      () async {
    final order = <String>[];
    final target = _target('self:nightscout');
    final scheduler = GlucoseSyncTaskScheduler(
      runner: _Runner(onRun: (target) => order.add(target.targetId)),
      now: () => DateTime(2026, 6, 22, 10),
    )
      ..enqueueTarget(
        target,
        priority: GlucoseSyncTaskPriority.background,
        reason: GlucoseSyncTaskReason.background,
      )
      ..enqueueTarget(
        target,
        priority: GlucoseSyncTaskPriority.manual,
        reason: GlucoseSyncTaskReason.manual,
      );

    final result = await scheduler.drain(settings: const AppSettings());

    expect(order, ['self:nightscout']);
    expect(result.results.single.success, isTrue);
  });

  test('scheduler runs different hosts concurrently', () async {
    var active = 0;
    var maxActive = 0;
    final scheduler = GlucoseSyncTaskScheduler(
      runner: _Runner(onRunAsync: (_) async {
        active++;
        if (active > maxActive) maxActive = active;
        await Future<void>.delayed(const Duration(milliseconds: 20));
        active--;
      }),
      workerPoolConfig: const GlucoseSyncWorkerPoolConfig(
        globalConcurrency: 2,
        perHostConcurrency: 1,
      ),
      now: () => DateTime(2026, 6, 22, 10),
    )
      ..enqueueTarget(
        _target('remote:a', url: 'http://a.example'),
        priority: GlucoseSyncTaskPriority.foreground,
      )
      ..enqueueTarget(
        _target('remote:b', url: 'http://b.example'),
        priority: GlucoseSyncTaskPriority.foreground,
      );

    await scheduler.drain(settings: const AppSettings());

    expect(maxActive, 2);
  });

  test('scheduler limits concurrent work for the same host', () async {
    var active = 0;
    var maxActive = 0;
    final scheduler = GlucoseSyncTaskScheduler(
      runner: _Runner(onRunAsync: (_) async {
        active++;
        if (active > maxActive) maxActive = active;
        await Future<void>.delayed(const Duration(milliseconds: 20));
        active--;
      }),
      workerPoolConfig: const GlucoseSyncWorkerPoolConfig(
        globalConcurrency: 2,
        perHostConcurrency: 1,
      ),
      now: () => DateTime(2026, 6, 22, 10),
    )
      ..enqueueTarget(
        _target('remote:a', url: 'http://same.example'),
        priority: GlucoseSyncTaskPriority.foreground,
      )
      ..enqueueTarget(
        _target('remote:b', url: 'http://same.example'),
        priority: GlucoseSyncTaskPriority.foreground,
      );

    await scheduler.drain(settings: const AppSettings());

    expect(maxActive, 1);
  });

  test('persistence limiter serializes database writes across targets',
      () async {
    var activeWrites = 0;
    var maxActiveWrites = 0;
    final scheduler = GlucoseSyncTaskScheduler(
      runner: _Runner(onPersistenceAsync: (limiter) async {
        await limiter?.run(() async {
          activeWrites++;
          if (activeWrites > maxActiveWrites) {
            maxActiveWrites = activeWrites;
          }
          await Future<void>.delayed(const Duration(milliseconds: 20));
          activeWrites--;
        });
      }),
      workerPoolConfig: const GlucoseSyncWorkerPoolConfig(
        globalConcurrency: 2,
        persistenceConcurrency: 1,
      ),
      now: () => DateTime(2026, 6, 22, 10),
    )
      ..enqueueTarget(
        _target('remote:a', url: 'http://a.example'),
        priority: GlucoseSyncTaskPriority.foreground,
      )
      ..enqueueTarget(
        _target('remote:b', url: 'http://b.example'),
        priority: GlucoseSyncTaskPriority.foreground,
      );

    await scheduler.drain(settings: const AppSettings());

    expect(maxActiveWrites, 1);
  });
}

GlucoseSyncTarget _target(String targetId, {String? url}) {
  return GlucoseSyncTarget(
    targetId: targetId,
    subjectId: 'self',
    label: targetId,
    kind: GlucoseSyncTargetKind.selfNightscout,
    source: _Source(),
    metadata: GlucoseSyncTargetSourceMetadata(nightscoutUrl: url),
  );
}

class _Runner implements GlucoseSyncTargetRunner {
  final void Function(GlucoseSyncTarget target)? onRun;
  final Future<void> Function(GlucoseSyncTarget target)? onRunAsync;
  final Future<void> Function(GlucoseSyncPersistenceLimiter? limiter)?
      onPersistenceAsync;

  _Runner({
    this.onRun,
    this.onRunAsync,
    this.onPersistenceAsync,
  });

  @override
  GlucoseSyncCoordinator get syncCoordinator =>
      throw UnsupportedError('unused');

  @override
  GlucoseSyncPersistenceLimiter? get persistenceLimiter => null;

  @override
  Future<GlucoseSyncResult> run({
    required GlucoseSyncTarget target,
    required AppSettings settings,
    GlucoseSyncPersistenceLimiter? persistenceLimiter,
    GlucoseSyncPlan? explicitPlan,
  }) async {
    onRun?.call(target);
    await onRunAsync?.call(target);
    await onPersistenceAsync?.call(persistenceLimiter);
    return GlucoseSyncResult(
      source: target.source.type,
      subjectId: target.subjectId,
      success: true,
      available: true,
      fetchedCount: 0,
      storedCount: 0,
      cursor: null,
      error: null,
      readings: const [],
    );
  }
}

class _Source implements IGlucoseSource {
  @override
  DataSource get type => DataSource.nightscout;

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<GlucoseReading?> latest() async => null;

  @override
  Future<List<GlucoseReading>> recent({int count = 24}) async => const [];

  @override
  Future<List<GlucoseReading>> range({
    required DateTime from,
    required DateTime to,
  }) async =>
      const [];
}
