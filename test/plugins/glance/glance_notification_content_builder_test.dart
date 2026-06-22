import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/plugins/glance/application/glance_snapshot_builder.dart';
import 'package:smart_xdrip/plugins/glance/application/notification/glance_notification_content_builder.dart';
import 'package:smart_xdrip/plugins/glance/domain/glance_display_mode.dart';
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

    expect(content.title, 'SolgoInsight');
    expect(content.body, contains(snapshot.valueLabel));
    expect(content.body, contains(snapshot.unitLabel));
    expect(content.body, contains(snapshot.tir24h.compactLabel));
    expect(content.body, isNot(contains(snapshot.deltaLabel)));
    expect(content.visibility, NotificationVisibility.public);
  });

  test('builds range-only content without exact glucose value', () {
    final snapshot = const FakeGlanceSnapshotFactory().inRange();
    final content = const GlanceNotificationContentBuilder().build(
      snapshot: snapshot,
      privacyMode: GlanceNotificationPrivacyMode.full,
      displayMode: GlanceDisplayMode.rangeOnly,
    );

    expect(content.body, contains('In range'));
    expect(content.body, contains(snapshot.tir24h.compactLabel));
    expect(content.body, contains(snapshot.freshness.label));
    expect(content.body, isNot(contains(snapshot.valueLabel)));
  });

  test('builds minimal AOD-friendly content', () {
    final snapshot = const FakeGlanceSnapshotFactory().inRange();
    final content = const GlanceNotificationContentBuilder().build(
      snapshot: snapshot,
      privacyMode: GlanceNotificationPrivacyMode.full,
      displayMode: GlanceDisplayMode.minimal,
      aodFriendly: true,
    );

    expect(content.body, contains(snapshot.valueLabel));
    expect(content.body, contains(snapshot.tir24h.compactLabel));
    expect(content.body, contains(snapshot.freshness.label));
    expect(content.body, isNot(contains(snapshot.unitLabel)));
  });

  test('stale content does not look current', () {
    final now = DateTime(2026, 6, 11, 12);
    final reading = GlucoseReading(
      timestamp: now.subtract(const Duration(minutes: 30)),
      value: 7.4,
    );
    final snapshot = const GlanceSnapshotBuilder().build(
      subjectId: 'self',
      settings: const AppSettings(),
      latest: reading,
      trendReadings: [reading],
      now: now,
    );
    final content = const GlanceNotificationContentBuilder().build(
      snapshot: snapshot,
      privacyMode: GlanceNotificationPrivacyMode.full,
    );

    expect(content.title, 'Glucose stale');
    expect(content.body, contains('Glucose stale'));
    expect(content.body, contains('30m'));
  });
}
