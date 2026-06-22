import 'package:smart_xdrip/domain/entities/glucose_reading.dart';

class CgmReadingEvidence {
  final String sourceLabel;
  final List<GlucoseReading> readings;
  final DateTime? generatedAt;
  final String? failureLabel;

  const CgmReadingEvidence({
    required this.sourceLabel,
    this.readings = const [],
    this.generatedAt,
    this.failureLabel,
  });

  const CgmReadingEvidence.none({
    this.sourceLabel = 'Active subject readings',
    this.failureLabel,
  })  : readings = const [],
        generatedAt = null;

  bool get available => readings.isNotEmpty;
}
