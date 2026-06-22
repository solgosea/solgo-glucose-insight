import 'package:flutter/widgets.dart';

import '../../l10n/generated/history_localizations.dart';
import 'history_l10n_resolver.dart';

extension HistoryL10nContext on BuildContext {
  HistoryLocalizations get historyL10n =>
      HistoryL10nResolver.resolve(Localizations.localeOf(this));
}
