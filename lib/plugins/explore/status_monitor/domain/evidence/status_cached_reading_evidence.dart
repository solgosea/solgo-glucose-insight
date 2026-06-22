import 'package:smart_xdrip/domain/entities/glucose_reading.dart';

class StatusCachedReadingEvidence {
  final String sourceLabel;
  final List<GlucoseReading> readings;
  final DateTime? generatedAt;
  final String? failureLabel;

  const StatusCachedReadingEvidence({
    required this.sourceLabel,
    this.readings = const [],
    this.generatedAt,
    this.failureLabel,
  });

  const StatusCachedReadingEvidence.none({
    this.sourceLabel = 'Cached local readings',
    this.failureLabel,
  })  : readings = const [],
        generatedAt = null;

  bool get available => readings.isNotEmpty;
}
