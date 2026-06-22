import 'nightscout_marker_confidence.dart';

class NightscoutMarkerSummary {
  final String title;
  final String body;
  final NightscoutMarkerConfidence confidence;

  const NightscoutMarkerSummary({
    required this.title,
    required this.body,
    required this.confidence,
  });

  const NightscoutMarkerSummary.empty()
      : title = 'No explicit uploader marker',
        body =
            'Nightscout entries or device status did not expose a usable uploader marker.',
        confidence = NightscoutMarkerConfidence.notExplicit;

  Map<String, Object?> toJson() => {
        'title': title,
        'body': body,
        'confidence': confidence.name,
      };

  factory NightscoutMarkerSummary.fromJson(Map<String, Object?> json) {
    return NightscoutMarkerSummary(
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      confidence: NightscoutMarkerConfidence.values.firstWhere(
        (confidence) => confidence.name == json['confidence'],
        orElse: () => NightscoutMarkerConfidence.notExplicit,
      ),
    );
  }
}
