import 'package:flutter/widgets.dart';

import '../../../plugin_platform/contracts/plugin_entry.dart';
import '../../../plugin_platform/i18n/plugin_entry_localizer.dart';
import 'alerting_l10n_resolver.dart';

class AlertingEntryLocalizer extends PluginEntryLocalizer {
  const AlertingEntryLocalizer();

  @override
  SectionPluginEntry localizeSection(SectionPluginEntry entry, Locale locale) {
    final l10n = AlertingL10nResolver.resolve(locale);
    return entry.copyWith(
      title: l10n.alertingTitle,
      subtitle: l10n.settingsEntrySubtitle,
    );
  }
}
