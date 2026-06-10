import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/background_sync/background_sync_coordinator.dart';
import 'package:smart_xdrip/application/background_sync/background_sync_post_task.dart';
import 'package:smart_xdrip/application/data_source_runtime/data_source_runtime_coordinator.dart';
import 'package:smart_xdrip/application/polling/polling_context_builder.dart';
import 'package:smart_xdrip/application/polling/polling_decision_service.dart';
import 'package:smart_xdrip/application/sync/glucose_sync_coordinator.dart';
import 'package:smart_xdrip/application/sync_orchestration/glucose_source_sync_orchestrator.dart';
import 'package:smart_xdrip/data/local/glucose_database.dart';
import 'package:smart_xdrip/data/local/settings_store.dart';
import 'package:smart_xdrip/data/repositories/glucose_repository_impl.dart';
import 'package:smart_xdrip/domain/data_source/data_source_kind.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/domain/entities/source_sync_state.dart';
import 'package:smart_xdrip/domain/polling/polling_mode.dart';
import 'package:smart_xdrip/domain/polling/polling_risk_level.dart';
import 'package:smart_xdrip/domain/sources/i_glucose_source.dart';

import '../../_support/fakes/fake_glucose_source.dart';
import '../../_support/fixtures/cgm_readings_fixture.dart';
import '../../_support/mock_cgm_http_server.dart';
import '../../_support/test_database.dart';

void main() {
  group('data sync mechanism coverage', () {
    test(
      'single-source sync is idempotent and records source success',
      () async {
        final database = TestDatabase.create();
        addTearDown(database.close);
        final now = DateTime.now();
        final readings = [
          GlucoseReading(
            timestamp: now.subtract(const Duration(minutes: 15)),
            value: 6.1,
          ),
          GlucoseReading(
            timestamp: now.subtract(const Duration(minutes: 10)),
            value: 6.3,
          ),
          GlucoseReading(
            timestamp: now.subtract(const Duration(minutes: 5)),
            value: 6.5,
          ),
        ];
        final source = FakeGlucoseSource(
          type: DataSource.nightscout,
          readings: readings,
        );
        final coordinator = GlucoseSyncCoordinator(database: database);

        final first = await coordinator.syncOnce(
          source: source,
          settings: const AppSettings(
            nightscoutBaseUrl: 'http://localhost:1337',
            nightscoutSyncEnabled: true,
          ),
        );
        final second = await coordinator.syncOnce(
          source: source,
          settings: const AppSettings(
            nightscoutBaseUrl: 'http://localhost:1337',
            nightscoutSyncEnabled: true,
          ),
        );

        expect(first.success, isTrue);
        expect(second.success, isTrue);
        expect(await database.rawReadings.count(), readings.length);
        expect(await database.count(), readings.length);

        final state = await database.getSourceState(DataSource.nightscout.name);
        expect(state?.lastSuccessAt, isNotNull);
        expect(state?.lastAttemptAt, isNotNull);
        expect(state?.lastError, isNull);
        expect(
          state?.lastCursor,
          readings.last.timestamp.millisecondsSinceEpoch.toString(),
        );
      },
    );

    test(
      'sync failure records source error and leaves canonical data untouched',
      () async {
        final database = TestDatabase.create();
        addTearDown(database.close);
        final coordinator = GlucoseSyncCoordinator(database: database);

        final result = await coordinator.syncOnce(
          source: FakeGlucoseSource(
            type: DataSource.xdripHttp,
            readings: const [],
            availabilityError: Exception('socket closed'),
          ),
          settings: const AppSettings(
            xdripBaseUrl: 'http://127.0.0.1:17580',
            xdripSyncEnabled: true,
          ),
        );

        expect(result.success, isFalse);
        expect(await database.count(), 0);
        expect(await database.rawReadings.count(), 0);

        final state = await database.getSourceState(DataSource.xdripHttp.name);
        expect(state?.lastAttemptAt, isNotNull);
        expect(state?.lastSuccessAt, isNull);
        expect(state?.lastError, isNotNull);
      },
    );

    test(
      'dual source merge prefers recent xDrip and historical Nightscout',
      () async {
        final database = TestDatabase.create();
        addTearDown(database.close);
        final now = DateTime.now();
        final recentTime = now.subtract(const Duration(minutes: 5));
        final historicalTime = now.subtract(const Duration(hours: 2));

        final nightscoutServer = MockCgmHttpServer(
          entries: CgmReadingsFixture.nightscoutEntries([
            GlucoseReading(timestamp: recentTime, value: 6.7),
            GlucoseReading(timestamp: historicalTime, value: 6.1),
          ]),
        );
        final xdripServer = MockCgmHttpServer(
          entries: CgmReadingsFixture.nightscoutEntries([
            GlucoseReading(timestamp: recentTime, value: 7.4),
            GlucoseReading(timestamp: historicalTime, value: 8.4),
          ]),
        );
        await nightscoutServer.start();
        await xdripServer.start();
        addTearDown(nightscoutServer.stop);
        addTearDown(xdripServer.stop);

        final settings = AppSettings(
          nightscoutBaseUrl: nightscoutServer.baseUri.toString(),
          nightscoutSyncEnabled: true,
          xdripBaseUrl: xdripServer.baseUri.toString(),
          xdripSyncEnabled: true,
        );

        final result = await GlucoseSourceSyncOrchestrator(
          database: database,
        ).syncConfiguredSources(settings: settings);

        expect(result.success, isTrue);
        expect(await database.rawReadings.count(), 4);

        final recent = await database.range(
          recentTime.subtract(const Duration(minutes: 1)),
          recentTime.add(const Duration(minutes: 1)),
        );
        final historical = await database.range(
          historicalTime.subtract(const Duration(minutes: 1)),
          historicalTime.add(const Duration(minutes: 1)),
        );
        expect(recent.single.value, closeTo(7.4, 0.08));
        expect(historical.single.value, closeTo(6.1, 0.08));
      },
    );

    test(
      'polling decision service reacts to synced low glucose state',
      () async {
        final database = TestDatabase.create();
        addTearDown(database.close);
        final now = DateTime.now();
        await database.upsertMany([
          GlucoseReading(
            timestamp: now.subtract(const Duration(minutes: 1)),
            value: 3.4,
          ),
        ], source: DataSource.xdripHttp.name);
        await database.recordSourceSuccess(DataSource.xdripHttp.name);

        final service = PollingDecisionService(
          contextBuilder: PollingContextBuilder(
            database: database,
            sourceStateLoader: (kind) => _sourceStateFor(database, kind),
          ),
        );

        final decision = await service.decide(
          settings: const AppSettings(
            xdripBaseUrl: 'http://127.0.0.1:17580',
            xdripSyncEnabled: true,
          ),
          mode: PollingMode.background,
        );

        expect(decision.nextInterval, const Duration(seconds: 30));
        expect(decision.riskLevel, PollingRiskLevel.dangerous);
      },
    );

    test(
      'background sync snapshot exposes dynamic next polling interval',
      () async {
        final database = TestDatabase.create();
        addTearDown(database.close);
        final lowTime = DateTime.now().subtract(const Duration(minutes: 1));
        final xdripServer = MockCgmHttpServer(
          entries: CgmReadingsFixture.nightscoutEntries([
            GlucoseReading(timestamp: lowTime, value: 3.3),
          ]),
        );
        await xdripServer.start();
        addTearDown(xdripServer.stop);

        final settings = AppSettings(
          xdripBaseUrl: xdripServer.baseUri.toString(),
          xdripSyncEnabled: true,
        );
        final pollingDecisionService = PollingDecisionService(
          contextBuilder: PollingContextBuilder(
            database: database,
            sourceStateLoader: (kind) => _sourceStateFor(database, kind),
          ),
        );
        final coordinator = BackgroundSyncCoordinator(
          settingsStore: _FixedSettingsStore(settings),
          database: database,
          runtimeCoordinator: DataSourceRuntimeCoordinator(
            syncStateLoader: (kind) => _sourceStateFor(database, kind),
            xdripSupported: true,
          ),
          repository: GlucoseRepositoryImpl(db: database),
          pollingDecisionService: pollingDecisionService,
        );
        addTearDown(coordinator.dispose);

        final snapshot = await coordinator.runOnce();

        expect(snapshot.status.name, 'synced');
        expect(snapshot.nextSyncInterval, const Duration(seconds: 30));
        expect(await database.count(), 1);
        expect(
          await database.getSourceState(DataSource.xdripHttp.name),
          isNotNull,
        );
      },
    );

    test('background sync runs post-sync tasks after glucose sync', () async {
      final database = TestDatabase.create();
      addTearDown(database.close);
      final now = DateTime.now();
      final xdripServer = MockCgmHttpServer(
        entries: CgmReadingsFixture.nightscoutEntries([
          GlucoseReading(timestamp: now, value: 6.3),
        ]),
      );
      await xdripServer.start();
      addTearDown(xdripServer.stop);

      final task = _CountingPostTask();
      final settings = AppSettings(
        xdripBaseUrl: xdripServer.baseUri.toString(),
        xdripSyncEnabled: true,
      );
      final coordinator = BackgroundSyncCoordinator(
        settingsStore: _FixedSettingsStore(settings),
        database: database,
        runtimeCoordinator: DataSourceRuntimeCoordinator(
          syncStateLoader: (kind) => _sourceStateFor(database, kind),
          xdripSupported: true,
        ),
        repository: GlucoseRepositoryImpl(db: database),
        pollingDecisionService: PollingDecisionService(
          contextBuilder: PollingContextBuilder(
            database: database,
            sourceStateLoader: (kind) => _sourceStateFor(database, kind),
          ),
        ),
        postTasks: [task],
      );
      addTearDown(coordinator.dispose);

      await coordinator.runOnce();

      expect(task.calls, 1);
      expect(task.lastContext?.syncSucceeded, isTrue);
      expect(task.lastContext?.runtimeSnapshots, isNotEmpty);
      expect(await database.count(), 1);
    });
  });
}

Future<SourceSyncState?> _sourceStateFor(
  GlucoseDatabase database,
  DataSourceKind kind,
) {
  return switch (kind) {
    DataSourceKind.xdripLocal => database.getSourceState(
      DataSource.xdripHttp.name,
    ),
    DataSourceKind.nightscout => database.getSourceState(
      DataSource.nightscout.name,
    ),
  };
}

class _FixedSettingsStore extends SettingsStore {
  final AppSettings fixed;

  _FixedSettingsStore(this.fixed);

  @override
  Future<AppSettings> load() async => fixed;

  @override
  Future<void> save(AppSettings s) async {}
}

class _CountingPostTask implements BackgroundSyncPostTask {
  int calls = 0;
  BackgroundSyncPostTaskContext? lastContext;

  @override
  Future<void> run(BackgroundSyncPostTaskContext context) async {
    calls++;
    lastContext = context;
  }
}
