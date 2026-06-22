import 'package:smart_xdrip/application/plugin_text/plugin_text_render_context.dart';

import '../../domain/statistics_heatmap_tag.dart';
import '../../domain/text/statistics_text_slot.dart';
import '../../domain/text/statistics_text_type.dart';
import 'statistics_text_renderer.dart';

class StatisticsHeatmapTextBuilder {
  final StatisticsTextRenderer renderer;

  const StatisticsHeatmapTextBuilder({
    this.renderer = const StatisticsTextRenderer(),
  });

  String title({
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) {
    return renderer.render(
      slot: StatisticsTextSlot.heatmapTitle,
      type: StatisticsTextType.defaultText,
      facts: const {},
      context: context,
    );
  }

  String tagLabel(
    StatisticsHeatmapTag tag, {
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) {
    final type = switch (tag) {
      StatisticsHeatmapTag.inTarget => StatisticsTextType.heatmapInTarget,
      StatisticsHeatmapTag.belowTarget => StatisticsTextType.heatmapBelowTarget,
      StatisticsHeatmapTag.needsAttention =>
        StatisticsTextType.heatmapNeedsAttention,
    };
    return renderer.render(
      slot: StatisticsTextSlot.heatmapTag,
      type: type,
      facts: const {},
      context: context,
    );
  }
}
