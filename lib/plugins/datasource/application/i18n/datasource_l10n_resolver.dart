import 'package:flutter/widgets.dart';

import '../../l10n/generated/datasource_localizations.dart';
import '../../l10n/generated/datasource_localizations_en.dart';

class DatasourceL10nResolver {
  const DatasourceL10nResolver._();

  static final DatasourceLocalizations fallback = DatasourceLocalizationsEn();

  static DatasourceLocalizations resolve(Locale locale) {
    if (!DatasourceLocalizations.delegate.isSupported(locale)) {
      return fallback;
    }
    return lookupDatasourceLocalizations(locale);
  }
}
