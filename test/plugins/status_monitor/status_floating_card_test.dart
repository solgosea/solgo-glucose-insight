import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/floating/status_floating_component_payload.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/floating/status_floating_payload.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_level.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/presentation/widgets_external/status_monitor_floating_card.dart';

void main() {
  testWidgets('floating card shows preview and permission prompt',
      (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;

    try {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatusMonitorFloatingCard(
              enabled: true,
              permissionGranted: false,
              payload: _payload(),
              onEnabledChanged: (_) {},
              onRequestPermission: () {},
            ),
          ),
        ),
      );

      expect(find.text('Floating Status Bar'), findsOneWidget);
      expect(find.text('Enable floating permission'), findsOneWidget);
      expect(find.text('Sensor 92'), findsOneWidget);
      expect(find.text('xDrip+ 78'), findsOneWidget);
      expect(find.text('Nightscout 95'), findsOneWidget);
      expect(find.text('AAPS 66'), findsOneWidget);
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });
}

StatusFloatingPayload _payload() {
  return const StatusFloatingPayload(
    level: StatusLevel.watch,
    headline: 'Watch uploader',
    freshnessLabel: '2m',
    hasConfiguredSource: true,
    isStale: false,
    components: [
      StatusFloatingComponentPayload(
        label: 'Sensor',
        level: StatusLevel.healthy,
        glyph: '\u25CF',
        score: 92,
        scoreLabel: '92',
      ),
      StatusFloatingComponentPayload(
        label: 'xDrip+',
        level: StatusLevel.watch,
        glyph: '\u25B2',
        score: 78,
        scoreLabel: '78',
      ),
      StatusFloatingComponentPayload(
        label: 'Nightscout',
        level: StatusLevel.healthy,
        glyph: '\u25CF',
        score: 95,
        scoreLabel: '95',
      ),
      StatusFloatingComponentPayload(
        label: 'AAPS',
        level: StatusLevel.unknown,
        glyph: '\u25CB',
        score: 66,
        scoreLabel: '66',
      ),
    ],
  );
}
