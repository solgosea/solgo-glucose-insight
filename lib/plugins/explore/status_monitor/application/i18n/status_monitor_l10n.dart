import 'package:flutter/widgets.dart';

import '../../l10n/generated/status_monitor_localizations.dart';
import 'status_monitor_l10n_resolver.dart';

extension StatusMonitorL10nContext on BuildContext {
  StatusMonitorLocalizations get statusMonitorL10n =>
      StatusMonitorL10nResolver.resolve(Localizations.localeOf(this));
}
