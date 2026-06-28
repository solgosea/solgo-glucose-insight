import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/sync/glucose_sync_coordinator.dart';
import 'package:smart_xdrip/domain/sources/i_glucose_source.dart';

import '../../_support/fakes/fake_glucose_source.dart';
import '../../_support/fixtures/app_settings_fixture.dart';
import '../../_support/fixtures/cgm_readings_fixture.dart';
import '../../_support/test_database.dart';

void main() {
  group('GlucoseSyncCoordinator', () {
    test('syncOnce persists readings and records success cursor', () async {
      final database = TestDatabase.create();
      addTearDown(database.close);
      final readings = CgmReadingsFixture.stableDay(
        start: DateTime.now().subtract(const Duration(hours: 2)),
        count: 12,
      );
      final source = FakeGlucoseSource(
        type: DataSource.nightscout,
        readings: readings,
      );

      final result = await GlucoseSyncCoordinator(database: database).syncOnce(
        source: source,
        settings: AppSettingsFixture.nightscout,
      );

      expect(result.success, isTrue);
      expect(result.fetchedCount, 12);
      expect(await database.count(), 12);
      expect(await database.rawReadings.count(), 12);
      final state = await database.getSourceState('nightscout');
      expect(state?.lastCursor,
          readings.last.timestamp.millisecondsSinceEpoch.toString());
      expect(state?.lastFetchedCount, 12);
      expect(state?.lastStoredCount, 12);
    });

    test('syncOnce is idempotent for duplicate source windows', () async {
      final database = TestDatabase.create();
      addTearDown(database.close);
      final readings = CgmReadingsFixture.stableDay(
        start: DateTime.now().subtract(const Duration(hours: 2)),
        count: 10,
      );
      final source = FakeGlucoseSource(
        type: DataSource.xdripHttp,
        readings: readings,
      );
      final coordinator = GlucoseSyncCoordinator(database: database);

      await coordinator.syncOnce(
        source: source,
        settings: AppSettingsFixture.xdrip,
      );
      await coordinator.syncOnce(
        source: source,
        settings: AppSettingsFixture.xdrip,
      );

      expect(await database.count(), 10);
      expect(await database.rawReadings.count(), 10);
      expect(source.availabilityChecks, 2);
      expect(source.rangeCalls, greaterThan(2));
    });

    test('initial sync uses smart daily chunks before persisting', () async {
      final database = TestDatabase.create();
      addTearDown(database.close);
      final readings = CgmReadingsFixture.stableDay(
        start: DateTime.now().subtract(const Duration(days: 6)),
        count: 12,
      );
      final source = FakeGlucoseSource(
        type: DataSource.nightscout,
        readings: readings,
      );

      final result = await GlucoseSyncCoordinator(database: database).syncOnce(
        source: source,
        settings: AppSettingsFixture.nightscout,
      );

      expect(result.success, isTrue);
      expect(source.rangeCalls, greaterThan(1));
      expect(source.rangeWindows.first.from.isBefore(readings.first.timestamp),
          isTrue);
      for (final window in source.rangeWindows) {
        expect(
          window.to.difference(window.from),
          lessThanOrEqualTo(const Duration(days: 1)),
        );
      }
    });

    test('unavailable source records error and does not fetch readings',
        () async {
      final database = TestDatabase.create();
      addTearDown(database.close);
      final source = FakeGlucoseSource(
        type: DataSource.xdripHttp,
        readings: CgmReadingsFixture.stableDay(count: 5),
        available: false,
      );

      final result = await GlucoseSyncCoordinator(database: database).syncOnce(
        source: source,
        settings: AppSettingsFixture.xdrip,
      );

      expect(result.success, isFalse);
      expect(result.available, isFalse);
      expect(source.rangeCalls, 0);
      expect(await database.count(), 0);
      final state = await database.getSourceState('xdripHttp');
      expect(state?.lastError, 'source_unavailable');
    });
  });
}
