import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/data/sources/xdrip_http_source.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';

import '../../_support/fixtures/cgm_readings_fixture.dart';
import '../../_support/mock_cgm_http_server.dart';

void main() {
  group('XdripHttpSource', () {
    test('detects a live local-compatible HTTP server', () async {
      final server = MockCgmHttpServer(entries: const []);
      await server.start();
      addTearDown(server.stop);

      final source = XdripHttpSource(baseUrl: server.baseUri.toString());

      expect(await source.isAvailable(), isTrue);
    });

    test(
      'loads recent entries sorted oldest to newest and converted to mmol/L',
      () async {
        final readings = CgmReadingsFixture.stableDay(
          start: DateTime(2026, 6, 4, 9),
          count: 8,
          value: 7,
        );
        final server = MockCgmHttpServer(
          entries:
              CgmReadingsFixture.nightscoutEntries(readings).reversed.toList(),
        );
        await server.start();
        addTearDown(server.stop);

        final source = XdripHttpSource(baseUrl: server.baseUri.toString());
        final result = await source.recent(count: 3);

        expect(result, hasLength(3));
        expect(result[0].timestamp.isBefore(result[1].timestamp), isTrue);
        expect(result.last.value, closeTo(7, 0.08));
      },
    );

    test('enriches readings with adjacent-point trend rate', () async {
      final readings = [
        GlucoseReading(timestamp: DateTime(2026, 6, 9, 10), value: 6.4),
        GlucoseReading(timestamp: DateTime(2026, 6, 9, 10, 5), value: 5.8),
      ];
      final server = MockCgmHttpServer(
        entries: CgmReadingsFixture.nightscoutEntries(readings),
      );
      await server.start();
      addTearDown(server.stop);

      final source = XdripHttpSource(baseUrl: server.baseUri.toString());
      final result = await source.recent(count: 2);

      expect(result.last.ratePerMin, closeTo(-0.12, 0.01));
    });
  });
}
