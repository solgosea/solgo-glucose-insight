import '../../domain/nightscout_markers/nightscout_marker.dart';
import '../../domain/nightscout_markers/nightscout_marker_confidence.dart';
import '../../domain/nightscout_markers/nightscout_marker_kind.dart';
import '../../domain/nightscout_markers/nightscout_marker_summary.dart';
import 'status_text_renderer.dart';

class StatusMarkerTextBuilder {
  final StatusTextRenderer renderer;

  const StatusMarkerTextBuilder({
    this.renderer = const StatusTextRenderer(),
  });

  NightscoutMarker renderMarker(NightscoutMarker marker) {
    final rendered = renderer.render(
      _detailKey(marker.kind),
      _facts(marker),
      fallback: marker.note,
    );
    return NightscoutMarker(
      kind: marker.kind,
      label: rendered.title ?? marker.label,
      value: marker.value,
      source: marker.source,
      confidence: marker.confidence,
      note: rendered.body,
    );
  }

  NightscoutMarkerSummary summary(List<NightscoutMarker> markers) {
    final selected = _first(markers, NightscoutMarkerKind.xdripMarker) ??
        _first(markers, NightscoutMarkerKind.dexcomShareMarker) ??
        _first(markers, NightscoutMarkerKind.deviceStatusUploader) ??
        _first(markers, NightscoutMarkerKind.entryUploader);
    final key = selected == null
        ? 'status.xdrip.marker.summary.empty.v1'
        : selected.kind == NightscoutMarkerKind.xdripMarker
            ? 'status.xdrip.marker.summary.xdrip_visible.v1'
            : selected.kind == NightscoutMarkerKind.dexcomShareMarker
                ? 'status.xdrip.marker.summary.dexcom_share_visible.v1'
                : 'status.xdrip.marker.summary.uploader_visible.v1';
    final rendered = renderer.render(
      key,
      selected == null ? const {} : _facts(selected),
    );
    return NightscoutMarkerSummary(
      title: rendered.title ?? rendered.body,
      body: rendered.body,
      confidence:
          selected?.confidence ?? NightscoutMarkerConfidence.notExplicit,
    );
  }

  String notice() {
    return renderer.render('status.xdrip.marker.notice.v1', const {}).body;
  }

  String _detailKey(NightscoutMarkerKind kind) {
    switch (kind) {
      case NightscoutMarkerKind.entryUploader:
        return 'status.xdrip.marker.detail.entry_uploader.v1';
      case NightscoutMarkerKind.deviceStatusUploader:
        return 'status.xdrip.marker.detail.device_status_uploader.v1';
      case NightscoutMarkerKind.xdripMarker:
        return 'status.xdrip.marker.detail.xdrip.v1';
      case NightscoutMarkerKind.dexcomShareMarker:
        return 'status.xdrip.marker.detail.dexcom_share.v1';
      case NightscoutMarkerKind.aapsOrLoopMarker:
        return 'status.xdrip.marker.detail.loop_aaps.v1';
      case NightscoutMarkerKind.batteryMarker:
        return 'status.xdrip.marker.detail.battery.v1';
      case NightscoutMarkerKind.companionModeNotExplicit:
        return 'status.xdrip.marker.detail.companion_not_explicit.v1';
      case NightscoutMarkerKind.clarityNotObservable:
        return 'status.xdrip.marker.detail.clarity_not_observable.v1';
    }
  }

  Map<String, Object?> _facts(NightscoutMarker marker) {
    return {
      'kind': marker.kind.name,
      'value': marker.value,
      'source': marker.source,
      'confidence': marker.confidence.name,
    };
  }

  NightscoutMarker? _first(
    List<NightscoutMarker> markers,
    NightscoutMarkerKind kind,
  ) {
    for (final marker in markers) {
      if (marker.kind == kind) return marker;
    }
    return null;
  }
}
