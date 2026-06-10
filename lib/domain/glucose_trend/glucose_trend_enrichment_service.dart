import '../entities/glucose_reading.dart';
import 'glucose_trend_direction_mapper.dart';
import 'glucose_trend_rate_calculator.dart';
import 'glucose_trend_sample.dart';

class GlucoseTrendEnrichmentService {
  final GlucoseTrendRateCalculator calculator;
  final GlucoseTrendDirectionMapper directionMapper;

  const GlucoseTrendEnrichmentService({
    this.calculator = const GlucoseTrendRateCalculator(),
    this.directionMapper = const GlucoseTrendDirectionMapper(),
  });

  List<GlucoseReading> enrichReadings(List<GlucoseReading> readings) {
    return enrichSamples(
      readings.map((reading) => GlucoseTrendSample(reading: reading)).toList(),
    );
  }

  List<GlucoseReading> enrichSamples(List<GlucoseTrendSample> samples) {
    if (samples.isEmpty) return const [];
    final sorted = [...samples]
      ..sort((a, b) => a.reading.timestamp.compareTo(b.reading.timestamp));

    final enriched = <GlucoseReading>[];
    for (final sample in sorted) {
      final reading = sample.reading;
      if (reading.ratePerMin != null) {
        enriched.add(reading);
        continue;
      }

      final previous = enriched.isEmpty ? null : enriched.last;
      final calculated =
          previous == null
              ? null
              : calculator.ratePerMin(previous: previous, current: reading);
      final fallback =
          calculated ?? directionMapper.fallbackRatePerMin(sample.direction);

      enriched.add(
        fallback == null
            ? reading
            : GlucoseReading(
              timestamp: reading.timestamp,
              value: reading.value,
              ratePerMin: fallback,
            ),
      );
    }
    return enriched;
  }
}
