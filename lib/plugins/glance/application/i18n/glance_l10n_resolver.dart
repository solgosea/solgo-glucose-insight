import 'package:flutter/widgets.dart';

import '../../l10n/generated/glance_localizations.dart';
import '../../l10n/generated/glance_localizations_en.dart';

class GlanceL10nResolver {
  const GlanceL10nResolver._();

  static final GlanceLocalizations fallback = GlanceLocalizationsEn();

  static GlanceLocalizations resolve(Locale locale) {
    if (!GlanceLocalizations.delegate.isSupported(locale)) {
      return fallback;
    }
    return lookupGlanceLocalizations(locale);
  }
}
