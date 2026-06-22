import 'dart:ui';

import '../i18n/alerting_l10n_resolver.dart';
import '../../l10n/generated/alerting_localizations.dart';
import 'alert_text_render_context.dart';

class AlertTextLocalizer {
  const AlertTextLocalizer._();

  static AlertingLocalizations forContext(AlertTextRenderContext context) {
    return AlertingL10nResolver.resolve(
      context.locale ?? PlatformDispatcher.instance.locale,
    );
  }
}
