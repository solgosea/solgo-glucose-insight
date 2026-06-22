import 'package:smart_xdrip/application/plugin_text/plugin_text_render_context.dart';

import '../../domain/text/statistics_text_slot.dart';
import '../../domain/text/statistics_text_type.dart';
import 'statistics_text_renderer.dart';

class StatisticsAgpTextBuilder {
  final StatisticsTextRenderer renderer;

  const StatisticsAgpTextBuilder({
    this.renderer = const StatisticsTextRenderer(),
  });

  String renderEmpty({
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) {
    return renderer.render(
      slot: StatisticsTextSlot.agpSummary,
      type: StatisticsTextType.agpNoData,
      facts: const {'notEnoughData': true},
      context: context,
    );
  }

  String renderNotEnoughWindowGuidance({
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) {
    return renderer.render(
      slot: StatisticsTextSlot.agpGuidance,
      type: StatisticsTextType.agpNotEnoughWindow,
      facts: const {},
      context: context,
    );
  }

  String renderDawn(
    Map<String, Object?> facts, {
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) {
    return renderer.render(
      slot: StatisticsTextSlot.agpSummary,
      type: StatisticsTextType.agpDawnRise,
      facts: facts,
      context: context,
    );
  }

  String renderPeak(
    Map<String, Object?> facts, {
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) {
    return renderer.render(
      slot: StatisticsTextSlot.agpSummary,
      type: StatisticsTextType.agpMedianPeak,
      facts: facts,
      context: context,
    );
  }

  String renderVariability(
    Map<String, Object?> facts, {
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) {
    return renderer.render(
      slot: StatisticsTextSlot.agpSummary,
      type: StatisticsTextType.agpVariability,
      facts: facts,
      context: context,
    );
  }
}
