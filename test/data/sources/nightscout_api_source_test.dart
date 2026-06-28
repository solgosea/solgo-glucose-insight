import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/data/sources/nightscout_api_source.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';

import '../../_support/fixtures/cgm_readings_fixture.dart';
import '../../_support/mock_cgm_http_server.dart';

void main() {
  group('NightscoutApiSource', () {
    test('checks availability through status endpoint', () async {
      final server = MockCgmHttpServer(entries: const []);
      await server.start();
      addTearDown(server.stop);

      final source = NightscoutApiSource(baseUrl: server.baseUri.toString());

      expect(await source.isAvailable(), isTrue);
    });

    test(
        'loads range entries, filters by window, sorts, and converts to mmol/L',
        () async {
      final readings = CgmReadingsFixture.stableDay(
        start: DateTime(2026, 6, 4),
        count: 12,
        value: 6,
      );
      final shuffledEntries =
          CgmReadingsFixture.nightscoutEntries(readings).reversed.toList();
      final server = MockCgmHttpServer(entries: shuffledEntries);
      await server.start();
      addTearDown(server.stop);

      final source = NightscoutApiSource(baseUrl: server.baseUri.toString());
      final from = readings[2].timestamp;
      final to = readings[6].timestamp;
      final result = await source.range(from: from, to: to);

      expect(result, hasLength(5));
      expect(result.first.timestamp, from);
      expect(result.last.timestamp, readings[6].timestamp);
      expect(result.first.value, closeTo(6, 0.06));
    });

    test('uses bounded count for an atomic range request', () async {
      final readings = CgmReadingsFixture.stableDay(
        start: DateTime(2026, 6, 1),
        count: 12 * 24,
        value: 6,
      );
      final server = MockCgmHttpServer(
        entries: CgmReadingsFixture.nightscoutEntries(readings),
      );
      await server.start();
      addTearDown(server.stop);

      final source = NightscoutApiSource(baseUrl: server.baseUri.toString());
      final result = await source.range(
        from: DateTime(2026, 6, 1),
        to: DateTime(2026, 6, 2),
      );

      expect(result, hasLength(readings.length));
      final entryRequests = server.requestUris
          .where((uri) => uri.path == '/api/v1/entries.json')
          .toList();
      expect(entryRequests, hasLength(1));
      expect(entryRequests.single.queryParameters['count'], isNot('100000'));
    });

    test('passes token query parameter when configured', () async {
      final readings = CgmReadingsFixture.stableDay(count: 1);
      final server = MockCgmHttpServer(
        entries: CgmReadingsFixture.nightscoutEntries(readings),
        requireToken: true,
        token: 'read-token',
      );
      await server.start();
      addTearDown(server.stop);

      final source = NightscoutApiSource(
        baseUrl: server.baseUri.toString(),
        token: 'read-token',
      );

      expect(await source.isAvailable(), isTrue);
      expect(await source.recent(count: 1), hasLength(1));
    });

    test('enriches readings with adjacent-point trend rate', () async {
      final readings = [
        GlucoseReading(
          timestamp: DateTime(2026, 6, 9, 10),
          value: 5.8,
        ),
        GlucoseReading(
          timestamp: DateTime(2026, 6, 9, 10, 5),
          value: 6.4,
        ),
      ];
      final server = MockCgmHttpServer(
        entries: CgmReadingsFixture.nightscoutEntries(readings),
      );
      await server.start();
      addTearDown(server.stop);

      final source = NightscoutApiSource(baseUrl: server.baseUri.toString());
      final result = await source.recent(count: 2);

      expect(result.last.ratePerMin, closeTo(0.12, 0.01));
    });
  });
}
