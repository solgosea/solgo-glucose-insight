import 'package:flutter/widgets.dart';

import '../../l10n/generated/home_localizations.dart';
import 'home_l10n_resolver.dart';

extension HomeL10nContext on BuildContext {
  HomeLocalizations get homeL10n =>
      HomeL10nResolver.resolve(Localizations.localeOf(this));
}
