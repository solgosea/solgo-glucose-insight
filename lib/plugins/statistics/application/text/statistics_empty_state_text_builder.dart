import 'package:smart_xdrip/application/plugin_text/plugin_text_render_context.dart';

import '../../domain/text/statistics_text_slot.dart';
import '../../domain/text/statistics_text_type.dart';
import 'statistics_text_renderer.dart';

class StatisticsEmptyStateTextBuilder {
  final StatisticsTextRenderer renderer;

  const StatisticsEmptyStateTextBuilder({
    this.renderer = const StatisticsTextRenderer(),
  });

  String noData({
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) {
    return renderer.render(
      slot: StatisticsTextSlot.emptyState,
      type: StatisticsTextType.noData,
      facts: const {},
      context: context,
    );
  }
}
