import 'package:flutter/widgets.dart';

import '../../l10n/generated/insights_localizations.dart';
import '../../l10n/generated/insights_localizations_en.dart';

class InsightsL10nResolver {
  const InsightsL10nResolver._();

  static final InsightsLocalizations fallback = InsightsLocalizationsEn();

  static InsightsLocalizations resolve(Locale locale) {
    if (!InsightsLocalizations.delegate.isSupported(locale)) {
      return fallback;
    }
    return lookupInsightsLocalizations(locale);
  }
}
