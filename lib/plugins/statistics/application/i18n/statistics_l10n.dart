import 'package:flutter/widgets.dart';

import '../../l10n/generated/statistics_localizations.dart';
import 'statistics_l10n_resolver.dart';

extension StatisticsL10nContext on BuildContext {
  StatisticsLocalizations get statisticsL10n =>
      StatisticsL10nResolver.resolve(Localizations.localeOf(this));
}
