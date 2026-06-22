import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_level.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/widget/status_widget_connection_state.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/widget/status_widget_snapshot.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/widget/status_widget_template.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/presentation/widgets/widget/status_widget_preview.dart';

void main() {
  testWidgets('status widget templates fit on phone width', (tester) async {
    tester.view.physicalSize = const Size(720, 1280);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              StatusWidgetTemplateGallery(snapshot: _snapshot()),
            ],
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(StatusWidgetTemplateGallery), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

StatusWidgetSnapshot _snapshot() {
  return const StatusWidgetSnapshot(
    subjectId: 'self',
    template: StatusWidgetTemplate.flow,
    headline: 'All links are healthy',
    summary: 'CGM, uploader, and Nightscout are reporting normally.',
    sourceLabel: 'Nightscout',
    updatedLabel: 'Updated just now',
    freshnessLabel: 'now',
    notificationText: 'All systems healthy - now',
    lockScreenText: 'All systems healthy - now',
    primaryIssueLabel: 'CGM Sensor',
    level: StatusLevel.healthy,
    score: 92,
    scoreLabel: '92',
    hasConfiguredSource: true,
    isStale: false,
    privateMode: false,
    components: [
      StatusWidgetComponentSnapshot(
        title: 'CGM Sensor',
        levelLabel: 'Healthy',
        level: StatusLevel.healthy,
        detail: 'Stable sensor signal',
        score: 94,
        scoreLabel: '94',
      ),
      StatusWidgetComponentSnapshot(
        title: 'xDrip+',
        levelLabel: 'Watch',
        level: StatusLevel.watch,
        detail: 'Upload latency needs attention',
        score: 78,
        scoreLabel: '78',
      ),
      StatusWidgetComponentSnapshot(
        title: 'Nightscout',
        levelLabel: 'Healthy',
        level: StatusLevel.healthy,
        detail: 'API reachable',
        score: 91,
        scoreLabel: '91',
      ),
    ],
    sensorToUploader: StatusWidgetConnectionState.watch,
    uploaderToServer: StatusWidgetConnectionState.healthy,
  );
}
