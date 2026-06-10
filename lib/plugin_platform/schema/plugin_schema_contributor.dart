import 'plugin_schema_context.dart';

abstract class PluginSchemaContributor {
  const PluginSchemaContributor();

  String get pluginId;

  int get schemaVersion;

  Future<void> install(PluginSchemaContext context);

  Future<void> migrate(
    PluginSchemaContext context, {
    required int fromVersion,
    required int toVersion,
  }) {
    return install(context);
  }
}
