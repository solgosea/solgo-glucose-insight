import 'package:flutter/widgets.dart';

import '../../l10n/generated/alerting_localizations.dart';
import 'alerting_l10n_resolver.dart';

extension AlertingL10nContext on BuildContext {
  AlertingLocalizations get alertingL10n =>
      AlertingL10nResolver.resolve(Localizations.localeOf(this));
}
