import 'package:flutter/widgets.dart';

import '../../l10n/generated/statistics_localizations.dart';
import '../../l10n/generated/statistics_localizations_en.dart';

class StatisticsL10nResolver {
  const StatisticsL10nResolver._();

  static final StatisticsLocalizations fallback = StatisticsLocalizationsEn();

  static StatisticsLocalizations resolve(Locale locale) {
    if (!StatisticsLocalizations.delegate.isSupported(locale)) {
      return fallback;
    }
    return lookupStatisticsLocalizations(locale);
  }
}
