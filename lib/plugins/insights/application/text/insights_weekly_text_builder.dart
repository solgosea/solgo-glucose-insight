import 'package:smart_xdrip/application/plugin_text/plugin_text_render_context.dart';

import '../../domain/text/insights_text_slot.dart';
import '../../domain/text/insights_text_type.dart';
import 'insights_text_renderer.dart';

class InsightsWeeklyTextBuilder {
  final InsightsTextRenderer renderer;

  const InsightsWeeklyTextBuilder({
    this.renderer = const InsightsTextRenderer(),
  });

  String eyebrow({
    required Map<String, Object?> facts,
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
    String fallback = '',
  }) {
    return _render(
      slot: InsightsTextSlot.weeklyEyebrow,
      type: InsightsTextType.weeklyReview,
      facts: facts,
      context: context,
      fallback: fallback,
    );
  }

  String body({
    required Map<String, Object?> facts,
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
    String fallback = '',
  }) {
    return _render(
      slot: InsightsTextSlot.weeklyBody,
      type: InsightsTextType.weeklyReview,
      facts: facts,
      context: context,
      fallback: fallback,
    );
  }

  String tirLabel({
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) =>
      _label(InsightsTextType.weeklyStatTir, context);

  String bestDayLabel({
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) =>
      _label(InsightsTextType.weeklyStatBestDay, context);

  String longestHighLabel({
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) =>
      _label(InsightsTextType.weeklyStatLongestHigh, context);

  String _label(String type, PluginTextRenderContext context) {
    return renderer.render(
      slot: InsightsTextSlot.weeklyMiniStatLabel,
      type: type,
      facts: const {},
      context: context,
    );
  }

  String _render({
    required String slot,
    required String type,
    required Map<String, Object?> facts,
    required PluginTextRenderContext context,
    required String fallback,
  }) {
    try {
      return renderer.render(
        slot: slot,
        type: type,
        facts: facts,
        context: context,
      );
    } on StateError {
      if (fallback.isNotEmpty) return fallback;
      return renderer.render(
        slot: InsightsTextSlot.emptyState,
        type: InsightsTextType.noData,
        facts: const {},
        context: context,
      );
    }
  }
}
