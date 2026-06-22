import 'package:flutter/widgets.dart';

import 'package:smart_xdrip/plugin_platform/contracts/plugin_entry.dart';
import 'package:smart_xdrip/plugin_platform/i18n/plugin_entry_localizer.dart';
import 'home_l10n_resolver.dart';

class HomeEntryLocalizer extends PluginEntryLocalizer {
  const HomeEntryLocalizer();

  @override
  MainTabPluginEntry localizeMainTab(
    MainTabPluginEntry entry,
    Locale locale,
  ) {
    final l10n = HomeL10nResolver.resolve(locale);
    return entry.copyWith(label: l10n.pluginTitle);
  }

  @override
  HomeWidgetPluginEntry localizeHomeWidget(
    HomeWidgetPluginEntry entry,
    Locale locale,
  ) {
    final l10n = HomeL10nResolver.resolve(locale);
    return switch (entry.widgetKey) {
      'home.header' => entry.copyWith(
          title: l10n.homeHeaderTitle,
          description: l10n.homeHeaderSubtitle,
        ),
      'home.hero_glucose' => entry.copyWith(
          title: l10n.homeHeroTitle,
          description: l10n.homeHeroSubtitle,
        ),
      'home.tir' => entry.copyWith(
          title: l10n.homeTirTitle,
          description: l10n.homeTirSubtitle,
        ),
      'home.range_chart' => entry.copyWith(
          title: l10n.homeRangeChartTitle,
          description: l10n.homeRangeChartSubtitle,
        ),
      'home.stats' => entry.copyWith(
          title: l10n.homeStatsTitle,
          description: l10n.homeStatsSubtitle,
        ),
      'home.insight' => entry.copyWith(
          title: l10n.homeInsightTitle,
          description: l10n.homeInsightSubtitle,
        ),
      _ => entry,
    };
  }
}
