import 'package:smart_xdrip/domain/insight/insight_slot_code.dart';
import 'package:smart_xdrip/domain/insight/insight_type_code.dart';

import 'plugin_text_renderer.dart';
import 'plugin_text_template.dart';
import 'plugin_text_template_selector.dart';

class InsightCodePluginTextRenderer {
  final List<PluginTextTemplate> templates;
  final PluginTextTemplateSelector selector;

  const InsightCodePluginTextRenderer({
    required this.templates,
    this.selector = const PluginTextTemplateSelector(),
  });

  String render({
    required InsightSlotCode slot,
    required InsightTypeCode type,
    required Map<String, Object?> facts,
  }) {
    final template = selector.select(
      templates: templates,
      slot: slot.code,
      type: type.code,
      facts: facts,
    );
    if (template == null) {
      throw StateError(
        'Missing plugin text template for ${slot.code}/${type.code}',
      );
    }
    return PluginTextRenderer(templates: templates)
        .render(template.key, facts)
        .body;
  }
}
