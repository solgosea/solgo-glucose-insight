import 'package:flutter/widgets.dart';

import '../../l10n/generated/background_localizations.dart';
import '../../l10n/generated/background_localizations_en.dart';

class BackgroundL10nResolver {
  const BackgroundL10nResolver._();

  static final BackgroundLocalizations fallback = BackgroundLocalizationsEn();

  static BackgroundLocalizations resolve(Locale locale) {
    if (!BackgroundLocalizations.delegate.isSupported(locale)) {
      return fallback;
    }
    return lookupBackgroundLocalizations(locale);
  }
}
