import 'package:flutter/widgets.dart';

import '../../l10n/generated/high_episode_localizations.dart';
import '../../l10n/generated/high_episode_localizations_en.dart';

class HighEpisodeL10nResolver {
  const HighEpisodeL10nResolver._();

  static final HighEpisodeLocalizations fallback = HighEpisodeLocalizationsEn();

  static HighEpisodeLocalizations resolve(Locale locale) {
    if (!HighEpisodeLocalizations.delegate.isSupported(locale)) {
      return fallback;
    }
    return lookupHighEpisodeLocalizations(locale);
  }
}
