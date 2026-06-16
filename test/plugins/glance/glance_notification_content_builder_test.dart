import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/glance/application/notification/glance_notification_content_builder.dart';
import 'package:smart_xdrip/plugins/glance/domain/notification_privacy_mode.dart';
import 'package:smart_xdrip/plugins/glance/test_support/fake_glance_snapshot_factory.dart';

void main() {
  test('builds private lock-screen content without glucose value', () {
    final snapshot = const FakeGlanceSnapshotFactory().inRange();
    final content = const GlanceNotificationContentBuilder().build(
      snapshot: snapshot,
      privacyMode: GlanceNotificationPrivacyMode.private,
    );

    expect(content.title, 'Glucose data available');
    expect(content.body, 'Unlock to view current glucose');
    expect(content.body, isNot(contains(snapshot.valueLabel)));
    expect(content.visibility, NotificationVisibility.private);
  });

  test('builds full lock-screen content with current glucose summary', () {
    final snapshot = const FakeGlanceSnapshotFactory().inRange();
    final content = const GlanceNotificationContentBuilder().build(
      snapshot: snapshot,
      privacyMode: GlanceNotificationPrivacyMode.full,
    );

    expect(content.title, 'Solgo Insight');
    expect(content.body, contains(snapshot.valueLabel));
    expect(content.body, contains(snapshot.unitLabel));
    expect(content.body, contains(snapshot.deltaLabel));
    expect(content.visibility, NotificationVisibility.public);
  });
}
