import 'package:flutter/widgets.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_entry.dart';
import 'package:smart_xdrip/plugin_platform/i18n/plugin_entry_localizer.dart';

import 'status_monitor_l10n_resolver.dart';

class StatusMonitorEntryLocalizer extends PluginEntryLocalizer {
  const StatusMonitorEntryLocalizer();

  @override
  ExplorePluginEntry localizeExplore(ExplorePluginEntry entry, Locale locale) {
    final l10n = StatusMonitorL10nResolver.resolve(locale);
    return entry.copyWith(
      section: l10n.pluginExploreSection,
      title: l10n.pluginTitle,
      subtitle: l10n.pluginSubtitle,
    );
  }
}
