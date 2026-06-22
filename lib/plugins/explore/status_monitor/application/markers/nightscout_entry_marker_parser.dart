import '../../domain/nightscout_markers/nightscout_marker.dart';
import '../../domain/nightscout_markers/nightscout_marker_confidence.dart';
import '../../domain/nightscout_markers/nightscout_marker_kind.dart';

class NightscoutEntryMarkerParser {
  const NightscoutEntryMarkerParser();

  List<NightscoutMarker> parse(List<Map<String, dynamic>> rows) {
    final markers = <NightscoutMarker>[];
    final labels = _uniqueDeviceLabels(rows);
    if (labels.isEmpty) return markers;

    final latest = labels.first;
    markers.add(
      NightscoutMarker(
        kind: NightscoutMarkerKind.entryUploader,
        label: '',
        value: latest,
        source: 'entries.device',
        confidence: NightscoutMarkerConfidence.medium,
        note: '',
      ),
    );

    final normalized = latest.toLowerCase();
    if (normalized.contains('xdrip')) {
      markers.add(
        NightscoutMarker(
          kind: NightscoutMarkerKind.xdripMarker,
          label: '',
          value: latest,
          source: 'entries.device',
          confidence: NightscoutMarkerConfidence.medium,
          note: '',
        ),
      );
    }
    if (normalized.contains('share')) {
      markers.add(
        NightscoutMarker(
          kind: NightscoutMarkerKind.dexcomShareMarker,
          label: '',
          value: latest,
          source: 'entries.device',
          confidence: NightscoutMarkerConfidence.low,
          note: '',
        ),
      );
    }
    if (_looksLikeLoop(latest)) {
      markers.add(
        NightscoutMarker(
          kind: NightscoutMarkerKind.aapsOrLoopMarker,
          label: '',
          value: latest,
          source: 'entries.device',
          confidence: NightscoutMarkerConfidence.medium,
          note: '',
        ),
      );
    }
    return markers;
  }

  List<String> _uniqueDeviceLabels(List<Map<String, dynamic>> rows) {
    final labels = <String>[];
    final seen = <String>{};
    for (final row in rows) {
      final label = row['device']?.toString().trim();
      if (label == null || label.isEmpty) continue;
      final key = label.toLowerCase();
      if (seen.add(key)) labels.add(label);
    }
    return labels;
  }

  bool _looksLikeLoop(String label) {
    final normalized = label.toLowerCase();
    return normalized.contains('aaps') ||
        normalized.contains('androidaps') ||
        normalized.contains('openaps') ||
        normalized.contains('loop') ||
        normalized.contains('trio');
  }
}
