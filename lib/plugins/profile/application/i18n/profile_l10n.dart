import 'package:flutter/widgets.dart';

import '../../l10n/generated/profile_localizations.dart';
import 'profile_l10n_resolver.dart';

extension ProfileL10nContext on BuildContext {
  ProfileLocalizations get profileL10n =>
      ProfileL10nResolver.resolve(Localizations.localeOf(this));
}
