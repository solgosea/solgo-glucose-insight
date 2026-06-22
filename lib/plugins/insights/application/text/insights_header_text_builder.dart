import 'package:smart_xdrip/application/plugin_text/plugin_text_render_context.dart';

import '../../domain/text/insights_text_slot.dart';
import '../../domain/text/insights_text_type.dart';
import 'insights_text_renderer.dart';

class InsightsHeaderTextBuilder {
  final InsightsTextRenderer renderer;

  const InsightsHeaderTextBuilder({
    this.renderer = const InsightsTextRenderer(),
  });

  String date(
    DateTime value, {
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) {
    final month = context.locale.startsWith('zh')
        ? value.month
        : _monthShort(value.month);
    return renderer.render(
      slot: InsightsTextSlot.headerDate,
      type: InsightsTextType.defaultText,
      facts: {
        'month': month,
        'day': value.day,
        'year': value.year,
      },
      context: context,
    );
  }

  String _monthShort(int month) {
    return switch (month) {
      1 => 'Jan',
      2 => 'Feb',
      3 => 'Mar',
      4 => 'Apr',
      5 => 'May',
      6 => 'Jun',
      7 => 'Jul',
      8 => 'Aug',
      9 => 'Sep',
      10 => 'Oct',
      11 => 'Nov',
      _ => 'Dec',
    };
  }
}
