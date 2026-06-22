import '../../domain/glance_display_mode.dart';
import '../../domain/glance_snapshot.dart';
import '../../l10n/generated/glance_localizations.dart';
import '../i18n/glance_l10n_resolver.dart';

class GlanceAodFriendlyContentBuilder {
  const GlanceAodFriendlyContentBuilder();

  String buildBody({
    required GlanceSnapshot snapshot,
    required GlanceDisplayMode mode,
    GlanceLocalizations? l10n,
  }) {
    final strings = l10n ?? GlanceL10nResolver.fallback;
    if (mode == GlanceDisplayMode.off) return strings.glanceNotificationHidden;
    if (mode == GlanceDisplayMode.private) {
      return strings.glanceNotificationStatusAvailable;
    }
    if (!snapshot.hasReading) return strings.glanceNotificationSourceOffline;
    if (snapshot.freshness.isStale) {
      return '${strings.glanceNotificationGlucoseStale} - '
          '${snapshot.freshness.label}';
    }
    if (mode == GlanceDisplayMode.rangeOnly) {
      return '${_rangeLabel(snapshot, strings)} - '
          '${snapshot.tir24h.compactLabel} - '
          '${snapshot.freshness.label}';
    }
    if (mode == GlanceDisplayMode.minimal) {
      return '${snapshot.valueLabel} - ${snapshot.tir24h.compactLabel} - '
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
