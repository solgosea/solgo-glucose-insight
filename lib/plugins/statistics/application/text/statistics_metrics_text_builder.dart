import 'package:smart_xdrip/application/plugin_text/plugin_text_render_context.dart';

import '../../domain/text/statistics_text_slot.dart';
import '../../domain/text/statistics_text_type.dart';
import 'statistics_text_renderer.dart';

class StatisticsMetricsTextBuilder {
  final StatisticsTextRenderer renderer;

  const StatisticsMetricsTextBuilder({
    this.renderer = const StatisticsTextRenderer(),
  });

  String header(
    String windowLabel, {
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) {
    return renderer.render(
      slot: StatisticsTextSlot.metricsHeader,
      type: StatisticsTextType.defaultText,
      facts: {'windowLabel': windowLabel},
      context: context,
    );
  }

  String tirLabel({
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) =>
      _label(StatisticsTextType.metricsTir, context: context);
  String averageLabel({
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) =>
      _label(StatisticsTextType.metricsAverage, context: context);
  String cvLabel({
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) =>
      _label(StatisticsTextType.metricsCv, context: context);
  String sdLabel({
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) =>
      _label(StatisticsTextType.metricsSd, context: context);

  String cvStatus({
    required bool stable,
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) {
    return renderer.render(
      slot: StatisticsTextSlot.metricsStatus,
      type: stable
          ? StatisticsTextType.metricsCvStable
          : StatisticsTextType.metricsCvElevated,
      facts: const {},
      context: context,
    );
  }

  String _label(
    String type, {
    required PluginTextRenderContext context,
  }) {
    return renderer.render(
      slot: StatisticsTextSlot.metricsLabel,
      type: type,
      facts: const {},
      context: context,
    );
  }
}
