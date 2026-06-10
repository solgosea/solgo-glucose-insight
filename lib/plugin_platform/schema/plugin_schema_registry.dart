import 'plugin_schema_contributor.dart';

class PluginSchemaRegistry {
  final Map<String, PluginSchemaContributor> _contributors = {};

  void register(PluginSchemaContributor contributor) {
    _contributors[contributor.pluginId] = contributor;
  }

  List<PluginSchemaContributor> get contributors =>
      List.unmodifiable(_contributors.values);

  PluginSchemaContributor? contributorFor(String pluginId) {
    return _contributors[pluginId];
  }
}
