import 'package:flutter/widgets.dart';

import '../../l10n/generated/report_localizations.dart';
import 'report_l10n_resolver.dart';

extension ReportL10nContext on BuildContext {
  ReportLocalizations get reportL10n =>
      ReportL10nResolver.resolve(Localizations.localeOf(this));
}
