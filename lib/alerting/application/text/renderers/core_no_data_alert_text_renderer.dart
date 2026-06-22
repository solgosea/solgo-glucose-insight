import '../../../domain/event/alert_category.dart';
import '../alert_rendered_text.dart';
import '../alert_text_localizer.dart';
import '../alert_text_render_context.dart';
import '../alert_text_render_request.dart';
import '../alert_text_renderer.dart';

class CoreNoDataAlertTextRenderer implements AlertTextRenderer {
  const CoreNoDataAlertTextRenderer();

  @override
  bool supports(AlertTextRenderRequest request) {
    return request.category == AlertCategory.noData;
  }

  @override
  AlertRenderedText render(
    AlertTextRenderRequest request,
    AlertTextRenderContext context,
  ) {
    final l10n = AlertTextLocalizer.forContext(context);
    final name = context.subjectDisplayName;
    final prefix = name == null || name.trim().isEmpty
        ? l10n.alertSubjectGlucoseData
        : name;
    return AlertRenderedText(
      title: l10n.alertTitleNoRecentGlucoseData,
      body: l10n.alertBodyNoRecentGlucoseData(prefix),
    );
  }
}
