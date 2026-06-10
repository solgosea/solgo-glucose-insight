import 'canonical_glucose_candidate.dart';
import 'raw_glucose_reading.dart';

class GlucoseEtlResult {
  final List<RawGlucoseReading> rawReadings;
  final List<CanonicalGlucoseCandidate> canonicalReadings;

  const GlucoseEtlResult({
    required this.rawReadings,
    required this.canonicalReadings,
  });

  int get rawCount => rawReadings.length;
  int get canonicalCount => canonicalReadings.length;
}
