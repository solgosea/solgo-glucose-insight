import 'package:flutter/widgets.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_entry.dart';
import 'package:smart_xdrip/plugin_platform/i18n/plugin_entry_localizer.dart';

import 'low_episode_l10n_resolver.dart';

class LowEpisodeEntryLocalizer extends PluginEntryLocalizer {
  const LowEpisodeEntryLocalizer();

  @override
  ExplorePluginEntry localizeExplore(ExplorePluginEntry entry, Locale locale) {
    final l10n = LowEpisodeL10nResolver.resolve(locale);
    return entry.copyWith(
      title: l10n.pluginTitle,
      subtitle: l10n.pluginSubtitle,
    );
  }
}
