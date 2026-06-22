import 'package:smart_xdrip/application/insight/template_renderer.dart';
import 'package:smart_xdrip/application/plugin_text/plugin_text_render_context.dart';

import '../../data/seed/status_monitor_default_text_templates.dart';
import '../../data/seed/status_monitor_zh_text_templates.dart';
import '../../domain/text/status_rendered_text.dart';
import '../../domain/text/status_text_template.dart';

const _statusTextTemplates = <StatusTextTemplate>[
  ...StatusMonitorDefaultTextTemplates.all,
  ...StatusMonitorZhTextTemplates.all,
];

class StatusTextRenderer {
  final TemplateRenderer renderer;
  final List<StatusTextTemplate> templates;
  final PluginTextRenderContext renderContext;

  const StatusTextRenderer({
    this.renderer = const TemplateRenderer(),
    this.templates = _statusTextTemplates,
    this.renderContext = const PluginTextRenderContext.english(),
  });

  StatusTextRenderer forContext(PluginTextRenderContext context) {
    return StatusTextRenderer(
      renderer: renderer,
      templates: templates,
      renderContext: context,
    );
  }

  StatusRenderedText render(
    String key,
    Map<String, Object?> facts, {
    String? fallback,
    PluginTextRenderContext? context,
  }) {
    final resolvedContext = context ?? renderContext;
    final template = _template(
      key,
      locale: resolvedContext.locale,
      fallbackLocale: resolvedContext.fallbackLocale,
    );
    if (template == null) {
      return StatusRenderedText(body: fallback ?? '');
    }
    return StatusRenderedText(
      title: _optional(template.titleTemplate, facts),
      body: renderer.render(template.bodyTemplate, facts),
      footer: _optional(template.footerTemplate, facts),
    );
  }

  StatusTextTemplate? _template(
    String key, {
    required String locale,
    required String fallbackLocale,
  }) {
    for (final candidate in _localeCandidates(locale, fallbackLocale)) {
      final match = _bestTemplate(key, candidate);
      if (match != null) return match;
    }
    return null;
  }

  StatusTextTemplate? _bestTemplate(String key, String locale) {
    final normalizedLocale = _normalizeLocale(locale);
    final matches = templates.where((template) {
      return template.key == key &&
          template.enabled &&
          _normalizeLocale(template.locale) == normalizedLocale;
    }).toList()
      ..sort((a, b) => a.priority.compareTo(b.priority));
    if (matches.isEmpty) return null;
    return matches.first;
  }

  List<String> _localeCandidates(String locale, String fallbackLocale) {
    final normalized = _normalizeLocale(locale);
    final fallback = _normalizeLocale(fallbackLocale);
    final raw = <String>[
      normalized,
      if (normalized.contains('_')) normalized.split('_').first,
      fallback,
    ];
    final seen = <String>{};
    final candidates = <String>[];
    for (final candidate in raw) {
      if (candidate.isEmpty || seen.contains(candidate)) continue;
      seen.add(candidate);
      candidates.add(candidate);
    }
    return candidates;
  }

  String _normalizeLocale(String locale) {
    final normalized = locale.trim().replaceAll('-', '_').toLowerCase();
    if (normalized.startsWith('zh')) return 'zh';
    if (normalized.startsWith('en')) return 'en';
    return normalized;
  }

  String? _optional(String? template, Map<String, Object?> facts) {
    if (template == null || template.isEmpty) return null;
    return renderer.render(template, facts);
  }
}
