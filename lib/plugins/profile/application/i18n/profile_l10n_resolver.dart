import 'package:flutter/widgets.dart';

import '../../l10n/generated/profile_localizations.dart';
import '../../l10n/generated/profile_localizations_en.dart';

class ProfileL10nResolver {
  const ProfileL10nResolver._();

  static final ProfileLocalizations fallback = ProfileLocalizationsEn();

  static ProfileLocalizations resolve(Locale locale) {
    if (!ProfileLocalizations.delegate.isSupported(locale)) {
      return fallback;
    }
    return lookupProfileLocalizations(locale);
  }
}
