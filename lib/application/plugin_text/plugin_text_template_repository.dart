import 'plugin_text_template.dart';

abstract class PluginTextTemplateRepository {
  Future<void> upsertAll(List<PluginTextTemplate> templates);
  Future<List<PluginTextTemplate>> loadEnabled();
}
