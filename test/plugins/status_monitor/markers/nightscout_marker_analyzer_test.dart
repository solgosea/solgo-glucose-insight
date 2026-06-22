import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/markers/nightscout_marker_analyzer.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/evidence/nightscout_evidence.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/nightscout_markers/nightscout_marker_kind.dart';

void main() {
  group('NightscoutMarkerAnalyzer', () {
    test('extracts xDrip entry and device status markers', () {
      final analysis = const NightscoutMarkerAnalyzer().analyze(
        NightscoutEvidence(
          configured: true,
          enabled: true,
          sourceLabel: 'Nightscout',
          generatedAt: DateTime(2026, 1, 1),
          rawEntries: const [
            {
              'type': 'sgv',
              'sgv': 126,
              'date': 1760000000000,
              'device': 'xDrip-DexcomG7',
            },
          ],
          deviceStatus: const [
            {
              'device': 'xDrip+',
              'uploaderBattery': 82,
            },
          ],
        ),
      );

      expect(analysis.summary.title, 'xDrip+ marker visible');
      expect(analysis.notice, contains('Nightscout markers help explain'));
      expect(
        analysis.markers.map((marker) => marker.kind),
        containsAll([
          NightscoutMarkerKind.entryUploader,
          NightscoutMarkerKind.xdripMarker,
          NightscoutMarkerKind.deviceStatusUploader,
          NightscoutMarkerKind.batteryMarker,
          NightscoutMarkerKind.companionModeNotExplicit,
          NightscoutMarkerKind.clarityNotObservable,
        ]),
      );
    });

    test('treats Dexcom Share as inferred and does not claim Clarity', () {
      final analysis = const NightscoutMarkerAnalyzer().analyze(
        NightscoutEvidence(
          configured: true,
          enabled: true,
          sourceLabel: 'Nightscout',
          rawEntries: const [
            {
              'type': 'sgv',
              'sgv': 125,
              'device': 'share2',
            },
          ],
        ),
      );

      final kinds = analysis.markers.map((marker) => marker.kind).toSet();
      expect(kinds, contains(NightscoutMarkerKind.dexcomShareMarker));
      expect(kinds, contains(NightscoutMarkerKind.clarityNotObservable));
      expect(analysis.summary.body, contains('cannot confirm'));
      expect(
        analysis.markers
            .firstWhere(
              (marker) =>
                  marker.kind == NightscoutMarkerKind.clarityNotObservable,
            )
            .note,
        contains('Clarity'),
      );
    });

    test('extracts loop context from devicestatus fields', () {
      final analysis = const NightscoutMarkerAnalyzer().analyze(
        NightscoutEvidence(
          configured: true,
          enabled: true,
          sourceLabel: 'Nightscout',
          deviceStatus: const [
            {
              'device': 'openaps://AndroidAPS',
              'openaps': {
                'iob': {'iob': 1.2},
              },
              'pump': {'status': 'normal'},
              'cob': 14,
            },
          ],
        ),
      );

      expect(
        analysis.markers.map((marker) => marker.kind),
        contains(NightscoutMarkerKind.aapsOrLoopMarker),
      );
    });
  });
}
