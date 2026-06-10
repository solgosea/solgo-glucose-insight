import '../../../plugin_platform/schema/plugin_schema_context.dart';
import '../../../plugin_platform/schema/plugin_schema_contributor.dart';
import '../sqlite/alerting_schema.dart';

class AlertingSchemaContributor extends PluginSchemaContributor {
  const AlertingSchemaContributor();

  @override
  String get pluginId => 'core.alerting';

  @override
  int get schemaVersion => 1;

  @override
  Future<void> install(PluginSchemaContext context) {
    return const AlertingSchema().create(context.database);
  }
}
