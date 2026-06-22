import 'nightscout_marker_confidence.dart';
import 'nightscout_marker_kind.dart';

class NightscoutMarker {
  final NightscoutMarkerKind kind;
  final String label;
  final String value;
  final String source;
  final NightscoutMarkerConfidence confidence;
  final String note;

  const NightscoutMarker({
    required this.kind,
    required this.label,
    required this.value,
    required this.source,
    required this.confidence,
    required this.note,
  });

  Map<String, Object?> toJson() => {
        'kind': kind.name,
        'label': label,
        'value': value,
        'source': source,
        'confidence': confidence.name,
        'note': note,
      };

  factory NightscoutMarker.fromJson(Map<String, Object?> json) {
    return NightscoutMarker(
      kind: NightscoutMarkerKind.values.firstWhere(
        (kind) => kind.name == json['kind'],
        orElse: () => NightscoutMarkerKind.entryUploader,
      ),
      label: json['label']?.toString() ?? '',
      value: json['value']?.toString() ?? '',
      source: json['source']?.toString() ?? '',
      confidence: NightscoutMarkerConfidence.values.firstWhere(
        (confidence) => confidence.name == json['confidence'],
        orElse: () => NightscoutMarkerConfidence.low,
      ),
      note: json['note']?.toString() ?? '',
    );
  }
}
