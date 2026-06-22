import 'package:flutter/widgets.dart';

import '../../l10n/generated/settings_localizations.dart';
import '../../l10n/generated/settings_localizations_en.dart';

class SettingsL10nResolver {
  const SettingsL10nResolver._();

  static final SettingsLocalizations fallback = SettingsLocalizationsEn();

  static SettingsLocalizations resolve(Locale locale) {
    if (!SettingsLocalizations.delegate.isSupported(locale)) {
      return fallback;
    }
    return lookupSettingsLocalizations(locale);
  }
}
