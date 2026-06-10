import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/domain/glucose_trend/glucose_trend_enrichment_service.dart';
import 'package:smart_xdrip/domain/glucose_trend/glucose_trend_sample.dart';

void main() {
  group('GlucoseTrendEnrichmentService', () {
    test('fills missing trend rates from adjacent glucose values', () {
      const service = GlucoseTrendEnrichmentService();
      final readings = [
        GlucoseReading(timestamp: DateTime(2026, 6, 9, 10), value: 5.8),
        GlucoseReading(timestamp: DateTime(2026, 6, 9, 10, 5), value: 6.3),
      ];

      final enriched = service.enrichReadings(readings);

      expect(enriched.first.ratePerMin, isNull);
      expect(enriched.last.ratePerMin, closeTo(0.10, 0.001));
    });

    test(
      'uses direction fallback only when adjacent calculation is unavailable',
      () {
        const service = GlucoseTrendEnrichmentService();
        final samples = [
          GlucoseTrendSample(
            reading: GlucoseReading(
              timestamp: DateTime(2026, 6, 9, 10),
              value: 5.8,
            ),
            direction: 'SingleDown',
          ),
        ];

        final enriched = service.enrichSamples(samples);

        expect(enriched.single.ratePerMin, -0.10);
      },
    );

    test('does not overwrite an existing trend rate', () {
      const service = GlucoseTrendEnrichmentService();
      final readings = [
        GlucoseReading(
          timestamp: DateTime(2026, 6, 9, 10),
          value: 5.8,
          ratePerMin: 0.03,
        ),
      ];

      expect(service.enrichReadings(readings).single.ratePerMin, 0.03);
    });
  });
}
