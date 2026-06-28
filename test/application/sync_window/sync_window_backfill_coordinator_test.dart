import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/subject/active_subject_service.dart';
import 'package:smart_xdrip/application/subject/active_subject_store.dart';
import 'package:smart_xdrip/application/sync/glucose_sync_coordinator.dart';
import 'package:smart_xdrip/application/sync_runtime/unified_glucose_sync_runtime.dart';
import 'package:smart_xdrip/application/sync_window/active_subject_sync_target_resolver.dart';
import 'package:smart_xdrip/application/sync_window/sync_window_backfill_coordinator.dart';
import 'package:smart_xdrip/application/sync_window/sync_window_coverage_resolver.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/domain/sources/i_glucose_source.dart';
import 'package:smart_xdrip/domain/subject/glucose_subject.dart';
import 'package:smart_xdrip/domain/sync_target/glucose_sync_target.dart';
import 'package:smart_xdrip/domain/sync_target/glucose_sync_target_kind.dart';
import 'package:smart_xdrip/application/sync_target/glucose_sync_target_provider.dart';
import 'package:smart_xdrip/application/sync_target/glucose_sync_target_registry.dart';
import 'package:smart_xdrip/application/sync_target/glucose_sync_target_runner.dart';

import '../../_support/fakes/fake_glucose_source.dart';
import '../../_support/test_database.dart';

void main() {
  test('window expansion runs backfill for active subject current target',
      () async {
    final now = DateTime(2026, 6, 24, 12);
    final database = TestDatabase.create();
    addTearDown(database.close);
    final source = FakeGlucoseSource(
      type: DataSource.nightscout,
      readings: [
        GlucoseReading(
          timestamp: now.subtract(const Duration(days: 20)),
          value: 6.8,
        ),
        GlucoseReading(
          timestamp: now.subtract(const Duration(days: 15)),
          value: 7.1,
        ),
      ],
    );
    final target = GlucoseSyncTarget(
      targetId: 'self:nightscout',
      subjectId: GlucoseSubject.selfId,
      label: 'Nightscout',
      kind: GlucoseSyncTargetKind.selfNightscout,
      source: source,
      primaryHistory: true,
    );
    final registry = GlucoseSyncTargetRegistry(
      providers: [
        _Provider([target]),
      ],
    );
    await database.recordSourceSuccess(
      'nightscout',
      cursor: now
          .subtract(const Duration(days: 14))
          .millisecondsSinceEpoch
          .toString(),
      subjectId: GlucoseSubject.selfId,
      coveredFrom: now.subtract(const Duration(days: 14)),
      coveredTo: now,
      syncWindowDays: 14,
    );
    await database.upsertMany([
      GlucoseReading(
        timestamp: now.subtract(const Duration(days: 14)),
        value: 6.5,
      ),
    ]);
    final runtime = UnifiedGlucoseSyncRuntime(
      executor: () => throw StateError('not used'),
      targetExecutor: ({
        required target,
        required settings,
        explicitPlan,
      }) {
        return GlucoseSyncTargetRunner(
          syncCoordinator: GlucoseSyncCoordinator(database: database),
        ).run(
          target: target,
          settings: settings,
          explicitPlan: explicitPlan,
        );
      },
      onCompleted: (_) async {},
      now: () => now,
    );
    final coordinator = SyncWindowBackfillCoordinator(
      targetResolver: ActiveSubjectSyncTargetResolver(
        activeSubjectService: ActiveSubjectService(store: ActiveSubjectStore()),
        targetRegistry: registry,
      ),
      coverageResolver: SyncWindowCoverageResolver(database: database),
      syncRuntime: runtime,
      now: () => now,
    );

    final result = await coordinator.handleSettingsChange(
      previous: const AppSettings(
        nightscoutSyncEnabled: true,
        initialSyncDays: 14,
      ),
      next: const AppSettings(
        nightscoutSyncEnabled: true,
        initialSyncDays: 30,
      ),
    );

    expect(result, isNotNull);
    expect(result!.sourceResult.sourceResults.single.success, isTrue);
    expect(source.rangeWindows, isNotEmpty);
    expect(
        source.rangeWindows.first.from, now.subtract(const Duration(days: 30)));
    expect(source.rangeWindows.last.to, now.subtract(const Duration(days: 14)));
    final state = await database.getSourceState('nightscout');
    expect(state?.coveredFrom, now.subtract(const Duration(days: 20)));
    expect(state?.syncWindowDays, 30);
  });

  test('same window recheck runs backfill when coverage is still short',
      () async {
    final now = DateTime(2026, 6, 24, 12);
    final database = TestDatabase.create();
    addTearDown(database.close);
    final source = FakeGlucoseSource(
      type: DataSource.nightscout,
      readings: [
        GlucoseReading(
          timestamp: now.subtract(const Duration(days: 20)),
          value: 6.8,
        ),
      ],
    );
    final target = GlucoseSyncTarget(
      targetId: 'self:nightscout',
      subjectId: GlucoseSubject.selfId,
      label: 'Nightscout',
      kind: GlucoseSyncTargetKind.selfNightscout,
      source: source,
      primaryHistory: true,
    );
    final registry = GlucoseSyncTargetRegistry(
      providers: [
        _Provider([target]),
      ],
    );
    await database.recordSourceSuccess(
      'nightscout',
      cursor: now
          .subtract(const Duration(days: 14))
          .millisecondsSinceEpoch
          .toString(),
      subjectId: GlucoseSubject.selfId,
      coveredFrom: now.subtract(const Duration(days: 14)),
      coveredTo: now,
      syncWindowDays: 30,
    );
    await database.upsertMany([
      GlucoseReading(
        timestamp: now.subtract(const Duration(days: 14)),
        value: 6.5,
      ),
    ]);
    final runtime = UnifiedGlucoseSyncRuntime(
      executor: () => throw StateError('not used'),
      targetExecutor: ({
        required target,
        required settings,
        explicitPlan,
      }) {
        return GlucoseSyncTargetRunner(
          syncCoordinator: GlucoseSyncCoordinator(database: database),
        ).run(
          target: target,
          settings: settings,
          explicitPlan: explicitPlan,
        );
      },
      onCompleted: (_) async {},
      now: () => now,
    );
    final coordinator = SyncWindowBackfillCoordinator(
      targetResolver: ActiveSubjectSyncTargetResolver(
        activeSubjectService: ActiveSubjectService(store: ActiveSubjectStore()),
        targetRegistry: registry,
      ),
      coverageResolver: SyncWindowCoverageResolver(database: database),
      syncRuntime: runtime,
      now: () => now,
    );

    final result = await coordinator.handleSettingsChange(
      previous: const AppSettings(
        nightscoutSyncEnabled: true,
        initialSyncDays: 30,
      ),
      next: const AppSettings(
        nightscoutSyncEnabled: true,
        initialSyncDays: 30,
      ),
    );

    expect(result, isNotNull);
    expect(
        source.rangeWindows.first.from, now.subtract(const Duration(days: 30)));
    expect(source.rangeWindows.last.to, now.subtract(const Duration(days: 14)));
    final state = await database.getSourceState('nightscout');
    expect(state?.coveredFrom, now.subtract(const Duration(days: 20)));
  });
}

class _Provider implements GlucoseSyncTargetProvider {
  final List<GlucoseSyncTarget> targets;

  const _Provider(this.targets);

  @override
  Future<List<GlucoseSyncTarget>> targetsFor(AppSettings settings) async {
    return targets;
  }
}
