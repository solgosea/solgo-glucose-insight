export '../../domain/text/history_text_type.dart';

import 'package:smart_xdrip/application/plugin_text/plugin_text_renderer.dart';
import 'package:smart_xdrip/application/plugin_text/plugin_text_render_context.dart';
import 'package:smart_xdrip/application/plugin_text/plugin_text_template.dart';

import '../../data/seed/history_default_text_templates.dart';
import '../../data/seed/history_zh_text_templates.dart';
import '../../domain/text/history_text_type.dart';

class HistoryTextRenderer {
  static const templates = [
    ...HistoryDefaultTextTemplates.all,
    ...HistoryZhTextTemplates.all,
  ];

  final PluginTextRenderer renderer;

  const HistoryTextRenderer({
    this.renderer = const PluginTextRenderer(
      templates: templates,
    ),
  });

  String render(
    HistoryTextTemplate template,
    Map<String, Object?> facts, {
    PluginTextRenderContext context = const PluginTextRenderContext.english(),
  }) {
    final selected = _select(template, context);
    return renderer.renderTemplate(selected, facts).body;
  }

  PluginTextTemplate _select(
    HistoryTextTemplate template,
    PluginTextRenderContext context,
  ) {
    final keys = <String>[
      if (_normalize(context.locale) == 'zh') _localizedKey(template.key, 'zh'),
      if (_normalize(context.fallbackLocale) == 'zh')
        _localizedKey(template.key, 'zh'),
      template.key,
    ];
    for (final key in keys) {
      for (final candidate in templates) {
        if (candidate.enabled && candidate.key == key) return candidate;
      }
    }
    throw StateError('Missing history text template for ${template.key}');
  }

  String _localizedKey(String key, String locale) {
    if (key.endsWith('.v1')) {
      return '${key.substring(0, key.length - 3)}.$locale.v1';
    }
    return '$key.$locale';
  }

  String _normalize(String locale) {
    final normalized = locale.trim().replaceAll('-', '_').toLowerCase();
    if (normalized.startsWith('zh')) return 'zh';
    if (normalized.startsWith('en')) return 'en';
    return normalized;
  }
}
