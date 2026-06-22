import '../../../domain/event/alert_category.dart';
import '../alert_rendered_text.dart';
import '../alert_text_localizer.dart';
import '../alert_text_render_context.dart';
import '../alert_text_render_request.dart';
import '../alert_text_renderer.dart';

class CoreGlucoseAlertTextRenderer implements AlertTextRenderer {
  const CoreGlucoseAlertTextRenderer();

  @override
  bool supports(AlertTextRenderRequest request) {
    return request.category == AlertCategory.glucoseHigh ||
        request.category == AlertCategory.glucoseLow ||
        request.category == AlertCategory.glucoseUrgentLow;
  }

  @override
  AlertRenderedText render(
    AlertTextRenderRequest request,
    AlertTextRenderContext context,
  ) {
    final l10n = AlertTextLocalizer.forContext(context);
    final value =
        request.result?.valueMmol ?? _double(request.payload['valueMmol']);
    final display = value == null
        ? l10n.alertSubjectCurrentGlucose
        : context.glucoseFormatter.value(value, context.unit).fullLabel;
    final name = context.subjectDisplayName;
    final prefix =
        name == null || name.trim().isEmpty ? l10n.alertSubjectGlucose : name;
    final title = switch (request.category) {
      AlertCategory.glucoseUrgentLow => l10n.alertTitleUrgentLowGlucose,
      AlertCategory.glucoseLow => l10n.alertTitleLowGlucose,
      AlertCategory.glucoseHigh => l10n.alertTitleHighGlucose,
      _ => l10n.alertTitleGlucoseAlert,
    };
    return AlertRenderedText(
      title: title,
      body: l10n.alertBodyGlucoseValue(prefix, display),
    );
  }

  double? _double(Object? raw) {
    if (raw is double) return raw;
    if (raw is int) return raw.toDouble();
    if (raw is num) return raw.toDouble();
    return double.tryParse(raw?.toString() ?? '');
  }
}
