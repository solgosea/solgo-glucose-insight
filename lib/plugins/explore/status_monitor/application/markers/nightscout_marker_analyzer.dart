import '../../domain/evidence/nightscout_evidence.dart';
import '../../domain/nightscout_markers/nightscout_marker.dart';
import '../../domain/nightscout_markers/nightscout_marker_analysis.dart';
import '../../domain/nightscout_markers/nightscout_marker_confidence.dart';
import '../../domain/nightscout_markers/nightscout_marker_kind.dart';
import '../text/status_marker_text_builder.dart';
import 'nightscout_device_status_marker_parser.dart';
import 'nightscout_entry_marker_parser.dart';

class NightscoutMarkerAnalyzer {
  final NightscoutEntryMarkerParser entryParser;
  final NightscoutDeviceStatusMarkerParser deviceStatusParser;
  final StatusMarkerTextBuilder textBuilder;

  const NightscoutMarkerAnalyzer({
    this.entryParser = const NightscoutEntryMarkerParser(),
    this.deviceStatusParser = const NightscoutDeviceStatusMarkerParser(),
    this.textBuilder = const StatusMarkerTextBuilder(),
  });

  NightscoutMarkerAnalysis analyze(NightscoutEvidence evidence) {
    final rawMarkers = <NightscoutMarker>[
      ...entryParser.parse(evidence.rawEntries),
      ...deviceStatusParser.parse(evidence.deviceStatus),
      const NightscoutMarker(
        kind: NightscoutMarkerKind.companionModeNotExplicit,
        label: '',
        value: 'not explicit',
        source: 'Nightscout schema',
        confidence: NightscoutMarkerConfidence.notExplicit,
        note: '',
      ),
      const NightscoutMarker(
        kind: NightscoutMarkerKind.clarityNotObservable,
        label: '',
        value: 'not observable',
        source: 'Nightscout schema',
        confidence: NightscoutMarkerConfidence.notExplicit,
        note: '',
      ),
    ];
    final markers =
        rawMarkers.map(textBuilder.renderMarker).toList(growable: false);
    return NightscoutMarkerAnalysis(
      summary: textBuilder.summary(markers),
      markers: markers,
      notice: textBuilder.notice(),
    );
  }
}
