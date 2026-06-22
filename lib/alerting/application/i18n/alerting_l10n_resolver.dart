import 'package:flutter/widgets.dart';

import '../../l10n/generated/alerting_localizations.dart';
import '../../l10n/generated/alerting_localizations_en.dart';

class AlertingL10nResolver {
  const AlertingL10nResolver._();

  static final AlertingLocalizations fallback = AlertingLocalizationsEn();

  static AlertingLocalizations resolve(Locale locale) {
    if (!AlertingLocalizations.delegate.isSupported(locale)) {
      return fallback;
    }
    return lookupAlertingLocalizations(locale);
  }
}
