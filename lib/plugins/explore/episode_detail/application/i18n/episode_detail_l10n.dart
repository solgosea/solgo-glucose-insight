import 'package:flutter/widgets.dart';

import '../../l10n/generated/episode_detail_localizations.dart';
import 'episode_detail_l10n_resolver.dart';

extension EpisodeDetailL10nContext on BuildContext {
  EpisodeDetailLocalizations get episodeDetailL10n =>
      EpisodeDetailL10nResolver.resolve(Localizations.localeOf(this));
}
