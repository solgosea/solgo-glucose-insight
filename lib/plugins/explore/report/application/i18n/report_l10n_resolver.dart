import 'package:flutter/widgets.dart';

import '../../l10n/generated/report_localizations.dart';
import '../../l10n/generated/report_localizations_en.dart';

class ReportL10nResolver {
  const ReportL10nResolver._();

  static final ReportLocalizations fallback = ReportLocalizationsEn();

  static ReportLocalizations resolve(Locale locale) {
    if (!ReportLocalizations.delegate.isSupported(locale)) {
      return fallback;
    }
    return lookupReportLocalizations(locale);
  }
}
