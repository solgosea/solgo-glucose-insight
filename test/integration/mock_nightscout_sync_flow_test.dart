import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/sync/glucose_sync_coordinator.dart';
import 'package:smart_xdrip/data/sources/nightscout_api_source.dart';

import '../_support/fixtures/app_settings_fixture.dart';
import '../_support/fixtures/cgm_readings_fixture.dart';
import '../_support/mock_cgm_http_server.dart';
import '../_support/test_database.dart';

void main() {
  group('Mock Nightscout sync flow', () {
    test(
      'pulls readings from HTTP source and persists normalized glucose data',
      () async {
        final readings = CgmReadingsFixture.dayWithHighAndLow(
          start: DateTime.now().subtract(const Duration(hours: 24)),
        );
        final server = MockCgmHttpServer(
          entries: CgmReadingsFixture.nightscoutEntries(readings),
        );
        await server.start();
        addTearDown(server.stop);

        final database = TestDatabase.create();
        addTearDown(database.close);
        final source = NightscoutApiSource(baseUrl: server.baseUri.toString());

        final result = await GlucoseSyncCoordinator(
          database: database,
        ).syncOnce(source: source, settings: AppSettingsFixture.nightscout);

        expect(result.success, isTrue);
        expect(await database.count(), readings.length);

        final persisted = await database.range(
          readings.first.timestamp,
          readings.last.timestamp.add(const Duration(milliseconds: 1)),
        );
        expect(persisted, hasLength(readings.length));
        expect(persisted.any((reading) => reading.value >= 10.8), isTrue);
        expect(persisted.any((reading) => reading.value <= 3.3), isTrue);
      },
    );
  });
}
