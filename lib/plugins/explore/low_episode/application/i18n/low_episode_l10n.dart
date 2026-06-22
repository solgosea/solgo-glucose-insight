import 'package:flutter/widgets.dart';

import '../../l10n/generated/low_episode_localizations.dart';
import 'low_episode_l10n_resolver.dart';

extension LowEpisodeL10nContext on BuildContext {
  LowEpisodeLocalizations get lowEpisodeL10n =>
      LowEpisodeL10nResolver.resolve(Localizations.localeOf(this));
}
