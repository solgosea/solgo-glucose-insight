import '../entities/glucose_reading.dart';

class GlucoseTrendSample {
  final GlucoseReading reading;
  final String? direction;

  const GlucoseTrendSample({required this.reading, this.direction});
}
