import '../../../domain/event/alert_category.dart';
import '../alert_rendered_text.dart';
import '../alert_text_localizer.dart';
import '../alert_text_render_context.dart';
import '../alert_text_render_request.dart';
import '../alert_text_renderer.dart';

class CoreRateAlertTextRenderer implements AlertTextRenderer {
  const CoreRateAlertTextRenderer();

  @override
  bool supports(AlertTextRenderRequest request) {
    return request.category == AlertCategory.glucoseRapidFall;
  }

  @override
  AlertRenderedText render(
    AlertTextRenderRequest request,
    AlertTextRenderContext context,
  ) {
    final l10n = AlertTextLocalizer.forContext(context);
    final rate = request.result?.rateMmolPerMin ??
        _double(request.payload['rateMmolPerMin']);
    final rateLabel = rate == null
        ? null
        : context.glucoseFormatter.rate(rate, context.unit).fullLabel;
    final name = context.subjectDisplayName;
    final prefix =
        name == null || name.trim().isEmpty ? l10n.alertSubjectGlucose : name;
    return AlertRenderedText(
      title: l10n.alertTitleRapidFall,
      body: rateLabel == null
          ? l10n.alertBodyRapidFall(prefix)
          : l10n.alertBodyRapidFallWithRate(prefix, rateLabel),
    );
  }

  double? _double(Object? raw) {
    if (raw is double) return raw;
    if (raw is int) return raw.toDouble();
    if (raw is num) return raw.toDouble();
    return double.tryParse(raw?.toString() ?? '');
  }
}
