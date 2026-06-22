import 'package:flutter/widgets.dart';

import '../../l10n/generated/home_localizations.dart';
import '../../l10n/generated/home_localizations_en.dart';

class HomeL10nResolver {
  const HomeL10nResolver._();

  static final HomeLocalizations fallback = HomeLocalizationsEn();

  static HomeLocalizations resolve(Locale locale) {
    if (!HomeLocalizations.delegate.isSupported(locale)) {
      return fallback;
    }
    return lookupHomeLocalizations(locale);
  }
}
