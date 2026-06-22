import 'package:flutter/widgets.dart';

import '../../l10n/generated/episode_detail_localizations.dart';
import '../../l10n/generated/episode_detail_localizations_en.dart';

class EpisodeDetailL10nResolver {
  const EpisodeDetailL10nResolver._();

  static final EpisodeDetailLocalizations fallback =
      EpisodeDetailLocalizationsEn();

  static EpisodeDetailLocalizations resolve(Locale locale) {
    if (!EpisodeDetailLocalizations.delegate.isSupported(locale)) {
      return fallback;
    }
    return lookupEpisodeDetailLocalizations(locale);
  }
}
