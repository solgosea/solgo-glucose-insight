import 'package:sqflite/sqflite.dart';
import 'package:smart_xdrip/application/plugin_text/plugin_text_template_schema.dart';

import 'statistics_template_tables.dart';

class StatisticsTemplateSchema {
  const StatisticsTemplateSchema();

  Future<void> install(Database database) {
    return const PluginTextTemplateSchema(
      StatisticsTemplateTables.textTemplates,
    ).install(database);
  }
}
