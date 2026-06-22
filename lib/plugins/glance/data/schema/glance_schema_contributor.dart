import '../../../../plugin_platform/schema/plugin_schema_context.dart';
import '../../../../plugin_platform/schema/plugin_schema_contributor.dart';
import '../sqlite/glance_schema.dart';

class GlanceSchemaContributor extends PluginSchemaContributor {
  const GlanceSchemaContributor();

  @override
  String get pluginId => 'glance.layer';

  @override
  int get schemaVersion => 3;

  @override
  Future<void> install(PluginSchemaContext context) {
    return const GlanceSchema().install(context.database);
  }
}
