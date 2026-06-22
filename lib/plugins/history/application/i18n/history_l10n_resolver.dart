import 'package:flutter/widgets.dart';

import '../../l10n/generated/history_localizations.dart';
import '../../l10n/generated/history_localizations_en.dart';

class HistoryL10nResolver {
  const HistoryL10nResolver._();

  static final HistoryLocalizations fallback = HistoryLocalizationsEn();

  static HistoryLocalizations resolve(Locale locale) {
    if (!HistoryLocalizations.delegate.isSupported(locale)) {
      return fallback;
    }
    return lookupHistoryLocalizations(locale);
  }
}
