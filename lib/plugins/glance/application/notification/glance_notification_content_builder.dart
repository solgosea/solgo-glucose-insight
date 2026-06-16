import '../../domain/glance_display_mode.dart';
import '../../domain/glance_snapshot.dart';
import '../../domain/notification_privacy_mode.dart';
import 'glance_aod_friendly_content_builder.dart';
import 'glance_notification_content.dart';
import 'glance_notification_visibility_policy.dart';

class GlanceNotificationContentBuilder {
  final GlanceAodFriendlyContentBuilder aodFriendlyContentBuilder;
  final GlanceNotificationVisibilityPolicy visibilityPolicy;

  const GlanceNotificationContentBuilder({
    this.aodFriendlyContentBuilder = const GlanceAodFriendlyContentBuilder(),
    this.visibilityPolicy = const GlanceNotificationVisibilityPolicy(),
  });

  GlanceNotificationContent build({
    required GlanceSnapshot snapshot,
    required GlanceNotificationPrivacyMode privacyMode,
    GlanceDisplayMode displayMode = GlanceDisplayMode.fullValue,
    bool aodFriendly = false,
  }) {
    final resolvedMode = privacyMode == GlanceNotificationPrivacyMode.private
        ? GlanceDisplayMode.private
        : displayMode;
    final private = resolvedMode == GlanceDisplayMode.private;
    final body = aodFriendly
        ? aodFriendlyContentBuilder.buildBody(
            snapshot: snapshot,
            mode: resolvedMode,
          )
        : _body(snapshot: snapshot, mode: resolvedMode);
    return GlanceNotificationContent(
      title: private ? 'Glucose data available' : _title(snapshot),
      body: body,
      visibility: visibilityPolicy.forDisplayMode(resolvedMode),
    );
  }

  String _title(GlanceSnapshot snapshot) {
    if (!snapshot.hasReading) return 'Source offline';
    if (snapshot.freshness.isStale) return 'Glucose stale';
    return 'Solgo Insight';
  }

  String _body({
    required GlanceSnapshot snapshot,
    required GlanceDisplayMode mode,
  }) {
    if (mode == GlanceDisplayMode.off) return 'Glance hidden';
    if (mode == GlanceDisplayMode.private) {
      return 'Unlock to view current glucose';
    }
    if (!snapshot.hasReading) return 'No recent glucose data';
    if (snapshot.freshness.isStale) {
      return 'Glucose stale · ${snapshot.freshness.label}';
    }
    if (mode == GlanceDisplayMode.rangeOnly) {
      return '${_rangeLabel(snapshot)} · ${snapshot.freshness.label}';
    }
    if (mode == GlanceDisplayMode.minimal) {
      return '${snapshot.valueLabel} ${snapshot.trendArrow} · '
          '${snapshot.freshness.label}';
    }
    return '${snapshot.valueLabel} ${snapshot.unitLabel} '
        '${snapshot.trendArrow} ${snapshot.deltaLabel} · '
        '${snapshot.freshness.label}';
  }

  String _rangeLabel(GlanceSnapshot snapshot) {
    return switch (snapshot.rangeState.code) {
      'high' => 'High',
      'low' => 'Low',
      'in_range' => 'In range',
      'stale' => 'Glucose stale',
      _ => 'Glucose status available',
    };
  }
}
