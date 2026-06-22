import 'package:flutter/widgets.dart';

import '../../l10n/generated/explore_localizations.dart';
import '../../l10n/generated/explore_localizations_en.dart';

class ExploreL10nResolver {
  const ExploreL10nResolver._();

  static final ExploreLocalizations fallback = ExploreLocalizationsEn();

  static ExploreLocalizations resolve(Locale locale) {
    if (!ExploreLocalizations.delegate.isSupported(locale)) {
      return fallback;
    }
    return lookupExploreLocalizations(locale);
  }
}
