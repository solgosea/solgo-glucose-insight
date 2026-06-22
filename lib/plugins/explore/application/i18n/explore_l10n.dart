import 'package:flutter/widgets.dart';

import '../../l10n/generated/explore_localizations.dart';
import 'explore_l10n_resolver.dart';

extension ExploreL10nContext on BuildContext {
  ExploreLocalizations get exploreL10n =>
      ExploreL10nResolver.resolve(Localizations.localeOf(this));
}

extension ExploreSectionTitleLocalizations on ExploreLocalizations {
  String sectionTitleFor(String section) {
    return switch (section) {
      'LABS' => sectionLabs,
      'TIME PATTERNS' => sectionTimePatterns,
      'GLUCOSE PROFILE' => sectionGlucoseProfile,
      'EPISODES' => sectionEpisodes,
      'CONNECTED CARE' => sectionConnectedCare,
      'SYSTEM STATUS' => sectionSystemStatus,
      _ => section,
    };
  }
}
