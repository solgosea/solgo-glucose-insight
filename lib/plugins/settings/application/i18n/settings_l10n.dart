import 'package:flutter/widgets.dart';

import '../../l10n/generated/settings_localizations.dart';
import 'settings_l10n_resolver.dart';

extension SettingsL10nContext on BuildContext {
  SettingsLocalizations get settingsL10n =>
      SettingsL10nResolver.resolve(Localizations.localeOf(this));
}
