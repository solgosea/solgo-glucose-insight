import 'package:flutter/widgets.dart';

import '../../l10n/generated/app_localizations.dart';
import 'app_formatters.dart';

extension AppL10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  AppFormatters get appFormatters => AppFormatters(l10n);
}
