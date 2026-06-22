import 'package:smart_xdrip/application/plugin_text/plugin_text_render_context.dart';

import '../../domain/text/insights_text_slot.dart';
import '../../domain/text/insights_text_type.dart';
import 'insights_text_renderer.dart';

class InsightsDailyTextBuilder {
  final InsightsTextRenderer renderer;

  const InsightsDailyTextBuilder({
    this.renderer = const InsightsTextRenderer(),
  });

  String body({
    required String type,
    required Map<String, Object?> facts,
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
    String fallback = '',
  }) {
    return _render(
      slot: InsightsTextSlot.dailyBody,
      type: type,
      facts: facts,
      context: context,
      fallback: fallback,
    );
  }

  String footer({
    required String type,
    required Map<String, Object?> facts,
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
    String fallback = '',
  }) {
    return _render(
      slot: InsightsTextSlot.dailyFooter,
      type: type,
      facts: facts,
      context: context,
      fallback: fallback,
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
