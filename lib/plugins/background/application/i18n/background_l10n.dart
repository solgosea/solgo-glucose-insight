import 'package:flutter/widgets.dart';

import '../../l10n/generated/background_localizations.dart';
import 'background_l10n_resolver.dart';

extension BackgroundL10nContext on BuildContext {
  BackgroundLocalizations get backgroundL10n =>
      BackgroundL10nResolver.resolve(Localizations.localeOf(this));
}
