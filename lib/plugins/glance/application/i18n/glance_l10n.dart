import 'package:flutter/widgets.dart';

import '../../l10n/generated/glance_localizations.dart';
import 'glance_l10n_resolver.dart';

extension GlanceL10nContext on BuildContext {
  GlanceLocalizations get glanceL10n =>
      GlanceL10nResolver.resolve(Localizations.localeOf(this));
}
