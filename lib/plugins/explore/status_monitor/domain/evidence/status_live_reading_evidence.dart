import 'package:smart_xdrip/domain/entities/glucose_reading.dart';

import 'status_evidence_source_kind.dart';

class StatusLiveReadingEvidence {
  final StatusEvidenceSourceKind sourceKind;
  final String sourceLabel;
  final List<GlucoseReading> readings;
  final DateTime? generatedAt;
  final String? failureLabel;

  const StatusLiveReadingEvidence({
    required this.sourceKind,
    required this.sourceLabel,
    this.readings = const [],
    this.generatedAt,
    this.failureLabel,
  });

  const StatusLiveReadingEvidence.none({
    this.failureLabel,
  })  : sourceKind = StatusEvidenceSourceKind.none,
        sourceLabel = 'No live readings',
        readings = const [],
        generatedAt = null;

  bool get available => readings.isNotEmpty;
}
