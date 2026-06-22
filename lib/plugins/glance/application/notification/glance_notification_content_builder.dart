import '../../domain/glance_display_mode.dart';
import '../../domain/glance_snapshot.dart';
import '../../domain/notification_privacy_mode.dart';
import '../../l10n/generated/glance_localizations.dart';
import '../i18n/glance_l10n_resolver.dart';
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
    GlanceLocalizations? l10n,
  }) {
    final strings = l10n ?? GlanceL10nResolver.fallback;
    final resolvedMode = privacyMode == GlanceNotificationPrivacyMode.private
        ? GlanceDisplayMode.private
        : displayMode;
    final private = resolvedMode == GlanceDisplayMode.private;
    final body = aodFriendly
        ? aodFriendlyContentBuilder.buildBody(
            snapshot: snapshot,
            mode: resolvedMode,
            l10n: strings,
          )
        : _body(snapshot: snapshot, mode: resolvedMode, l10n: strings);
    return GlanceNotificationContent(
      title: private
          ? strings.glanceNotificationGlucoseDataAvailable
          : _title(snapshot, strings),
      body: body,
      visibility: visibilityPolicy.forDisplayMode(resolvedMode),
    );
  }

  String _title(GlanceSnapshot snapshot, GlanceLocalizations l10n) {
    if (!snapshot.hasReading) return l10n.glanceNotificationSourceOffline;
    if (snapshot.freshness.isStale) {
      return l10n.glanceNotificationGlucoseStale;
    }
    return 'SolgoInsight';
  }

  String _body({
    required GlanceSnapshot snapshot,
    required GlanceDisplayMode mode,
    required GlanceLocalizations l10n,
  }) {
    if (mode == GlanceDisplayMode.off) return l10n.glanceNotificationHidden;
    if (mode == GlanceDisplayMode.private) {
      return l10n.glanceNotificationUnlockCurrentGlucose;
    }
    if (!snapshot.hasReading) return l10n.glanceNotificationNoRecentGlucoseData;
    if (snapshot.freshness.isStale) {
      return '${l10n.glanceNotificationGlucoseStale} - '
          '${snapshot.freshness.label}';
    }
    if (mode == GlanceDisplayMode.rangeOnly) {
      return '${_rangeLabel(snapshot, l10n)} - '
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
