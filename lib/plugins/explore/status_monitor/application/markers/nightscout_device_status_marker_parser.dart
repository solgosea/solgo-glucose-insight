import '../../domain/nightscout_markers/nightscout_marker.dart';
import '../../domain/nightscout_markers/nightscout_marker_confidence.dart';
import '../../domain/nightscout_markers/nightscout_marker_kind.dart';

class NightscoutDeviceStatusMarkerParser {
  const NightscoutDeviceStatusMarkerParser();

  List<NightscoutMarker> parse(List<Map<String, dynamic>> rows) {
    final markers = <NightscoutMarker>[];
    if (rows.isEmpty) return markers;

    final latest = rows.first;
    final device = latest['device']?.toString().trim();
    if (device != null && device.isNotEmpty) {
      markers.add(
        NightscoutMarker(
          kind: NightscoutMarkerKind.deviceStatusUploader,
          label: '',
          value: device,
          source: 'devicestatus.device',
          confidence: NightscoutMarkerConfidence.medium,
          note: '',
        ),
      );
      if (_looksLikeLoop(device)) {
        markers.add(
          NightscoutMarker(
            kind: NightscoutMarkerKind.aapsOrLoopMarker,
            label: '',
            value: device,
            source: 'devicestatus.device',
            confidence: NightscoutMarkerConfidence.medium,
            note: '',
          ),
        );
      }
    }

    final battery = _batteryLabel(latest);
    if (battery != null) {
      markers.add(
        NightscoutMarker(
          kind: NightscoutMarkerKind.batteryMarker,
          label: '',
          value: battery,
          source: 'devicestatus.uploaderBattery',
          confidence: NightscoutMarkerConfidence.high,
          note: '',
        ),
      );
    }

    if (_hasLoopFields(latest)) {
      markers.add(
        NightscoutMarker(
          kind: NightscoutMarkerKind.aapsOrLoopMarker,
          label: '',
          value: 'visible',
          source: 'devicestatus.openaps/pump/iob/cob',
          confidence: NightscoutMarkerConfidence.high,
          note: '',
        ),
      );
    }
    return markers;
  }

  String? _batteryLabel(Map<String, dynamic> row) {
    final direct = row['uploaderBattery'];
    if (direct != null) return '$direct%';
    final uploader = row['uploader'];
    if (uploader is Map && uploader['battery'] != null) {
      return '${uploader['battery']}%';
    }
    return null;
  }

  bool _hasLoopFields(Map<String, dynamic> row) {
    return _notEmptyMap(row['openaps']) ||
        _notEmptyMap(row['loop']) ||
        _notEmptyMap(row['pump']) ||
        row['iob'] != null ||
        row['cob'] != null ||
        row['profile'] != null ||
        row['profileName'] != null ||
        row['tempTarget'] != null;
  }

  bool _notEmptyMap(Object? value) => value is Map && value.isNotEmpty;

  bool _looksLikeLoop(String label) {
    final normalized = label.toLowerCase();
    return normalized.contains('aaps') ||
        normalized.contains('androidaps') ||
        normalized.contains('openaps') ||
        normalized.contains('loop') ||
        normalized.contains('trio');
  }
}
