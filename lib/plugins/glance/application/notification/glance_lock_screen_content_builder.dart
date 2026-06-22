import '../../domain/glance_lock_screen_mode.dart';
import '../../domain/glance_snapshot.dart';
import '../../l10n/generated/glance_localizations.dart';
import '../i18n/glance_l10n_resolver.dart';
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
    GlanceLocalizations? l10n,
  }) {
    final strings = l10n ?? GlanceL10nResolver.fallback;
    final title = _title(snapshot: snapshot, mode: mode, l10n: strings);
    final body = _body(snapshot: snapshot, mode: mode, l10n: strings);
    return GlanceNotificationContent(
      title: title,
      body: body,
      visibility: visibilityPolicy.forLockScreenMode(mode),
    );
  }

  String _title({
    required GlanceSnapshot snapshot,
    required GlanceLockScreenMode mode,
    required GlanceLocalizations l10n,
  }) {
    if (mode == GlanceLockScreenMode.private) {
      return l10n.glanceNotificationStatusAvailable;
    }
    if (snapshot.freshness.isStale && snapshot.hasReading) {
      return l10n.glanceNotificationGlucoseStale;
    }
    if (!snapshot.hasReading) {
      return l10n.glanceNotificationSourceOffline;
    }
    return 'SolgoInsight';
  }

  String _body({
    required GlanceSnapshot snapshot,
    required GlanceLockScreenMode mode,
    required GlanceLocalizations l10n,
  }) {
    if (mode == GlanceLockScreenMode.off) {
      return l10n.glanceNotificationHiddenOnLockScreen;
    }
    if (mode == GlanceLockScreenMode.private) {
      return l10n.glanceNotificationUnlockCurrentGlucose;
    }
    if (!snapshot.hasReading) {
      return l10n.glanceNotificationNoRecentGlucoseData;
    }
    if (snapshot.freshness.isStale) {
      return '${l10n.glanceNotificationGlucoseStale} - '
          '${snapshot.freshness.label}';
    }
    if (mode == GlanceLockScreenMode.rangeOnly) {
      return '${_rangeLabel(snapshot, l10n)} - '
          '${snapshot.tir24h.compactLabel} - '
          '${snapshot.freshness.label}';
    }
    return '${snapshot.valueLabel} ${snapshot.unitLabel} - '
        '${snapshot.tir24h.compactLabel} - ${snapshot.freshness.label}';
  }

  String _rangeLabel(GlanceSnapshot snapshot, GlanceLocalizations l10n) {
    return switch (snapshot.rangeState.code) {
      'high' => l10n.glanceNotificationRangeHigh,
      'low' => l10n.glanceNotificationRangeLow,
      'in_range' => l10n.glanceNotificationRangeInRange,
      'stale' => l10n.glanceNotificationGlucoseStale,
      _ => l10n.glanceNotificationStatusAvailable,
    };
  }
}
