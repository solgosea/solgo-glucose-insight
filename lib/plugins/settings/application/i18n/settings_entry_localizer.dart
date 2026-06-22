import 'package:flutter/widgets.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_entry.dart';
import 'package:smart_xdrip/plugin_platform/i18n/plugin_entry_localizer.dart';

import 'settings_l10n_resolver.dart';

class SettingsEntryLocalizer extends PluginEntryLocalizer {
  const SettingsEntryLocalizer();

  @override
  SectionPluginEntry localizeSection(SectionPluginEntry entry, Locale locale) {
    final l10n = SettingsL10nResolver.resolve(locale);
    return switch (entry.title) {
      'Display' => entry.copyWith(
          title: l10n.settingsDisplayTitle,
          subtitle: l10n.settingsDisplaySubtitle,
        ),
      'Sync Settings' => entry.copyWith(
          title: l10n.settingsSyncTitle,
          subtitle: l10n.settingsSyncSubtitle,
        ),
      'Data Storage' => entry.copyWith(
          title: l10n.settingsStorageTitle,
          subtitle: l10n.settingsStorageSubtitle,
        ),
      'Data Export' => entry.copyWith(
          title: l10n.settingsExportTitle,
          subtitle: l10n.settingsExportSubtitle,
        ),
      'About' => entry.copyWith(
          title: l10n.settingsAboutTitle,
          subtitle: l10n.settingsAboutSubtitle,
        ),
      'Danger Zone' => entry.copyWith(
          title: l10n.settingsDangerTitle,
          subtitle: l10n.settingsDangerSubtitle,
        ),
      _ => entry.copyWith(
          title: l10n.pluginTitle,
          subtitle: l10n.pluginSubtitle,
        ),
    };
  }
}
