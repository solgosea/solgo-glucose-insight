import 'package:smart_xdrip/plugin_platform/schema/plugin_schema_contributor.dart';
import 'package:smart_xdrip/plugin_platform/schema/plugin_schema_context.dart';

import '../sqlite/statistics_template_schema.dart';

class StatisticsTemplateSchemaContributor extends PluginSchemaContributor {
  const StatisticsTemplateSchemaContributor();

  @override
  String get pluginId => 'core.statistics';

  @override
  int get schemaVersion => 1;

  @override
  Future<void> install(PluginSchemaContext context) {
    return const StatisticsTemplateSchema().install(context.database);
  }
}
