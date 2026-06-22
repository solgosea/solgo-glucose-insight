import 'nightscout_marker.dart';
import 'nightscout_marker_summary.dart';

class NightscoutMarkerAnalysis {
  final NightscoutMarkerSummary summary;
  final List<NightscoutMarker> markers;
  final String notice;

  const NightscoutMarkerAnalysis({
    required this.summary,
    required this.markers,
    required this.notice,
  });

  const NightscoutMarkerAnalysis.empty()
      : summary = const NightscoutMarkerSummary.empty(),
        markers = const [],
        notice = '';

  Map<String, Object?> toJson() => {
        'summary': summary.toJson(),
        'markers': markers.map((marker) => marker.toJson()).toList(),
        'notice': notice,
      };

  factory NightscoutMarkerAnalysis.fromJson(Map<String, Object?> json) {
    final rows = json['markers'];
    return NightscoutMarkerAnalysis(
      summary: json['summary'] is Map
          ? NightscoutMarkerSummary.fromJson(
              Map<String, Object?>.from(json['summary'] as Map),
            )
          : const NightscoutMarkerSummary.empty(),
      markers: rows is List
          ? rows
              .whereType<Map>()
              .map(
                (row) => NightscoutMarker.fromJson(
                  Map<String, Object?>.from(row),
                ),
              )
              .toList(growable: false)
          : const [],
      notice: json['notice']?.toString() ?? '',
    );
  }
}
