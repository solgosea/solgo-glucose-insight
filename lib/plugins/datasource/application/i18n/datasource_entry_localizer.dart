import 'package:flutter/widgets.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_entry.dart';
import 'package:smart_xdrip/plugin_platform/i18n/plugin_entry_localizer.dart';

import 'datasource_l10n_resolver.dart';

class DatasourceEntryLocalizer extends PluginEntryLocalizer {
  const DatasourceEntryLocalizer();

  @override
  SectionPluginEntry localizeSection(SectionPluginEntry entry, Locale locale) {
    final l10n = DatasourceL10nResolver.resolve(locale);
    return entry.copyWith(
      title: l10n.pluginTitle,
      subtitle: l10n.pluginSubtitle,
    );
  }
}
