import 'package:flutter/widgets.dart';

import 'package:smart_xdrip/plugin_platform/contracts/plugin_entry.dart';
import 'package:smart_xdrip/plugin_platform/i18n/plugin_entry_localizer.dart';
import 'explore_l10n_resolver.dart';

class ExploreEntryLocalizer extends PluginEntryLocalizer {
  const ExploreEntryLocalizer();

  @override
  MainTabPluginEntry localizeMainTab(
    MainTabPluginEntry entry,
    Locale locale,
  ) {
    return entry.copyWith(
      label: ExploreL10nResolver.resolve(locale).pluginTitle,
    );
  }
}
