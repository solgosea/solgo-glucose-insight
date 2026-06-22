import 'package:flutter/widgets.dart';

import 'package:smart_xdrip/plugin_platform/contracts/plugin_entry.dart';
import 'package:smart_xdrip/plugin_platform/i18n/plugin_entry_localizer.dart';
import 'profile_l10n_resolver.dart';

class ProfileEntryLocalizer extends PluginEntryLocalizer {
  const ProfileEntryLocalizer();

  @override
  MainTabPluginEntry localizeMainTab(
    MainTabPluginEntry entry,
    Locale locale,
  ) {
    return entry.copyWith(
      label: ProfileL10nResolver.resolve(locale).pluginTitle,
    );
  }

  @override
  SectionPluginEntry localizeSection(
    SectionPluginEntry entry,
    Locale locale,
  ) {
    final l10n = ProfileL10nResolver.resolve(locale);
    return switch (entry.title) {
      'Target Range' => entry.copyWith(
          title: l10n.targetRangeTitle,
          subtitle: l10n.targetRangeSubtitle,
        ),
      _ => entry.copyWith(
          title: l10n.pluginTitle,
          subtitle: l10n.pluginSubtitle,
        ),
    };
  }
}
