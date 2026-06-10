import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/sync_orchestration/glucose_source_sync_orchestrator.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/domain/sources/i_glucose_source.dart';

import '../../_support/fixtures/cgm_readings_fixture.dart';
import '../../_support/mock_cgm_http_server.dart';
import '../../_support/test_database.dart';

void main() {
  group('dual source merge flow', () {
    test(
      'syncs enabled Nightscout and xDrip sources into one canonical row',
      () async {
        final now = DateTime.now();
        final sampleTime = now.subtract(const Duration(hours: 2));
        final nightscoutReading = GlucoseReading(
          timestamp: sampleTime,
          value: 6.7,
        );
        final xdripReading = GlucoseReading(timestamp: sampleTime, value: 7.4);

        final nightscoutServer = MockCgmHttpServer(
          entries: CgmReadingsFixture.nightscoutEntries([nightscoutReading]),
        );
        final xdripServer = MockCgmHttpServer(
          entries: CgmReadingsFixture.nightscoutEntries([xdripReading]),
        );
        await nightscoutServer.start();
        await xdripServer.start();
        addTearDown(nightscoutServer.stop);
        addTearDown(xdripServer.stop);

        final database = TestDatabase.create();
        addTearDown(database.close);

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
        expect(result.sourceResults.map((entry) => entry.source), [
          DataSource.nightscout,
          DataSource.xdripHttp,
        ]);
        expect(await database.rawReadings.count(), 2);

        final canonical = await database.range(
          sampleTime.subtract(const Duration(minutes: 1)),
          sampleTime.add(const Duration(minutes: 1)),
        );
        expect(canonical, hasLength(1));
        expect(canonical.single.value, closeTo(6.7, 0.08));
      },
    );

    test('does not sync configured but disabled sources', () async {
      final now = DateTime.now();
      final sampleTime = now.subtract(const Duration(hours: 1));
      final nightscoutServer = MockCgmHttpServer(
        entries: CgmReadingsFixture.nightscoutEntries([
          GlucoseReading(timestamp: sampleTime, value: 6.2),
        ]),
      );
      final xdripServer = MockCgmHttpServer(
        entries: CgmReadingsFixture.nightscoutEntries([
          GlucoseReading(timestamp: sampleTime, value: 8.1),
        ]),
      );
      await nightscoutServer.start();
      await xdripServer.start();
      addTearDown(nightscoutServer.stop);
      addTearDown(xdripServer.stop);

      final database = TestDatabase.create();
      addTearDown(database.close);

      final settings = AppSettings(
        nightscoutBaseUrl: nightscoutServer.baseUri.toString(),
        xdripBaseUrl: xdripServer.baseUri.toString(),
      );

      final result = await GlucoseSourceSyncOrchestrator(
        database: database,
      ).syncConfiguredSources(settings: settings);

      expect(result.sourceResults, isEmpty);
      expect(result.success, isFalse);
      expect(result.fetchedCount, 0);
      expect(await database.count(), 0);
      expect(await database.rawReadings.count(), 0);
    });
  });
}
