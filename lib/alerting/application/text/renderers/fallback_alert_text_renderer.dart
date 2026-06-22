import '../alert_rendered_text.dart';
import '../alert_text_localizer.dart';
import '../alert_text_render_context.dart';
import '../alert_text_render_request.dart';
import '../alert_text_renderer.dart';

class FallbackAlertTextRenderer implements AlertTextRenderer {
  const FallbackAlertTextRenderer();

  @override
  bool supports(AlertTextRenderRequest request) => true;

  @override
  AlertRenderedText render(
    AlertTextRenderRequest request,
    AlertTextRenderContext context,
  ) {
    final l10n = AlertTextLocalizer.forContext(context);
    return AlertRenderedText(
      title: request.result?.title ?? l10n.alertFallbackTitle,
      body: request.result?.body ?? l10n.alertFallbackBody,
    );
  }
}
