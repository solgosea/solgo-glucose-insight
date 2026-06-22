import 'package:flutter/widgets.dart';

import '../../l10n/generated/high_episode_localizations.dart';
import 'high_episode_l10n_resolver.dart';

extension HighEpisodeL10nContext on BuildContext {
  HighEpisodeLocalizations get highEpisodeL10n =>
      HighEpisodeL10nResolver.resolve(Localizations.localeOf(this));
}
