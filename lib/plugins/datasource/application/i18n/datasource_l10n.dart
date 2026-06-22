import 'package:flutter/widgets.dart';

import '../../l10n/generated/datasource_localizations.dart';
import 'datasource_l10n_resolver.dart';

extension DatasourceL10nContext on BuildContext {
  DatasourceLocalizations get datasourceL10n =>
      DatasourceL10nResolver.resolve(Localizations.localeOf(this));
}
