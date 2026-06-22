import 'package:smart_xdrip/application/plugin_text/plugin_text_render_context.dart';

import '../../domain/text/statistics_text_slot.dart';
import '../../domain/text/statistics_text_type.dart';
import 'statistics_text_renderer.dart';

class StatisticsTirTextBuilder {
  final StatisticsTextRenderer renderer;

  const StatisticsTirTextBuilder({
    this.renderer = const StatisticsTextRenderer(),
  });

  String lowLegend(
    String percent, {
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) =>
      _legend(
        StatisticsTextType.tirLow,
        percent,
        context: context,
      );

  String inRangeLegend(
    String percent, {
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) =>
      _legend(
        StatisticsTextType.tirInRange,
        percent,
        context: context,
      );

  String highLegend(
    String percent, {
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) =>
      _legend(
        StatisticsTextType.tirHigh,
        percent,
        context: context,
      );

  String veryHighLegend(
    String percent, {
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) =>
      _legend(
        StatisticsTextType.tirVeryHigh,
        percent,
        context: context,
      );

  String veryLowExtreme(
    String threshold, {
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) =>
      _extreme(
        StatisticsTextType.tirVeryLow,
        threshold,
        context: context,
      );

  String veryHighExtreme(
    String threshold, {
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) =>
      _extreme(
        StatisticsTextType.tirVeryHigh,
        threshold,
        context: context,
      );

  String _legend(
    String type,
    String percent, {
    required PluginTextRenderContext context,
  }) {
    return renderer.render(
      slot: StatisticsTextSlot.tirLegend,
      type: type,
      facts: {'percent': percent},
      context: context,
    );
  }

  String _extreme(
    String type,
    String threshold, {
    required PluginTextRenderContext context,
  }) {
    return renderer.render(
      slot: StatisticsTextSlot.tirExtreme,
      type: type,
      facts: {'threshold': threshold},
      context: context,
    );
  }
}
