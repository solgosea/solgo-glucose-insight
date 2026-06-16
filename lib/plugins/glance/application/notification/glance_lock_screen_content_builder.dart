import '../../domain/glance_lock_screen_mode.dart';
import '../../domain/glance_snapshot.dart';
import 'glance_notification_content.dart';
import 'glance_notification_visibility_policy.dart';

class GlanceLockScreenContentBuilder {
  final GlanceNotificationVisibilityPolicy visibilityPolicy;

  const GlanceLockScreenContentBuilder({
    this.visibilityPolicy = const GlanceNotificationVisibilityPolicy(),
  });

  GlanceNotificationContent build({
    required GlanceSnapshot snapshot,
    required GlanceLockScreenMode mode,
  }) {
    final title = _title(snapshot: snapshot, mode: mode);
    final body = _body(snapshot: snapshot, mode: mode);
    return GlanceNotificationContent(
      title: title,
      body: body,
      visibility: visibilityPolicy.forLockScreenMode(mode),
    );
  }

  String _title({
    required GlanceSnapshot snapshot,
    required GlanceLockScreenMode mode,
  }) {
    if (mode == GlanceLockScreenMode.private) {
      return 'Glucose status available';
    }
    if (snapshot.freshness.isStale && snapshot.hasReading) {
      return 'Glucose stale';
    }
    if (!snapshot.hasReading) {
      return 'Source offline';
    }
    return 'Solgo Insight';
  }

  String _body({
    required GlanceSnapshot snapshot,
    required GlanceLockScreenMode mode,
  }) {
    if (mode == GlanceLockScreenMode.off) {
      return 'Glance is hidden on lock screen';
    }
    if (mode == GlanceLockScreenMode.private) {
      return 'Unlock to view current glucose';
    }
    if (!snapshot.hasReading) {
      return 'No recent glucose data';
    }
    if (snapshot.freshness.isStale) {
      return 'Glucose stale · ${snapshot.freshness.label}';
    }
    if (mode == GlanceLockScreenMode.rangeOnly) {
      return '${_rangeLabel(snapshot)} · ${snapshot.freshness.label}';
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
