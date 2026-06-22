import 'package:flutter/widgets.dart';

import '../../l10n/generated/low_episode_localizations.dart';
import '../../l10n/generated/low_episode_localizations_en.dart';

class LowEpisodeL10nResolver {
  const LowEpisodeL10nResolver._();

  static final LowEpisodeLocalizations fallback = LowEpisodeLocalizationsEn();

  static LowEpisodeLocalizations resolve(Locale locale) {
    if (!LowEpisodeLocalizations.delegate.isSupported(locale)) {
      return fallback;
    }
    return lookupLowEpisodeLocalizations(locale);
  }
}
