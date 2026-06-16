import 'plugin_text_template.dart';
import 'plugin_text_template_repository.dart';

class PluginTextTemplateInstaller {
  final PluginTextTemplateRepository repository;
  final List<PluginTextTemplate> templates;
  bool _installed = false;

  PluginTextTemplateInstaller({
    required this.repository,
    required this.templates,
  });

  Future<void> ensureInstalled() async {
    if (_installed) return;
    await repository.upsertAll(templates);
    _installed = true;
  }
}
