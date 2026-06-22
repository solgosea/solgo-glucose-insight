import 'package:flutter/widgets.dart';

import '../../l10n/generated/insights_localizations.dart';
import 'insights_l10n_resolver.dart';

extension InsightsL10nContext on BuildContext {
  InsightsLocalizations get insightsL10n =>
      InsightsL10nResolver.resolve(Localizations.localeOf(this));
}
