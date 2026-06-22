import 'package:smart_xdrip/application/plugin_text/plugin_text_render_context.dart';

import '../../domain/text/insights_text_slot.dart';
import '../../domain/text/insights_text_type.dart';
import 'insights_text_renderer.dart';

class InsightsEmptyStateTextBuilder {
  final InsightsTextRenderer renderer;

  const InsightsEmptyStateTextBuilder({
    this.renderer = const InsightsTextRenderer(),
  });

  String noData({
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) {
    return renderer.render(
      slot: InsightsTextSlot.emptyState,
      type: InsightsTextType.noData,
      facts: const {},
      context: context,
    );
  }
}
