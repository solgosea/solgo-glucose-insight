import 'package:flutter/widgets.dart';

import '../../l10n/generated/status_monitor_localizations.dart';
import '../../l10n/generated/status_monitor_localizations_en.dart';

class StatusMonitorL10nResolver {
  const StatusMonitorL10nResolver._();

  static final StatusMonitorLocalizations fallback =
      StatusMonitorLocalizationsEn();

  static StatusMonitorLocalizations resolve(Locale locale) {
    if (!StatusMonitorLocalizations.delegate.isSupported(locale)) {
      return fallback;
    }
    return lookupStatusMonitorLocalizations(locale);
  }
}
