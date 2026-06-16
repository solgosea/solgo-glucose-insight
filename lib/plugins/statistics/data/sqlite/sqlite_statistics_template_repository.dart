import 'package:smart_xdrip/application/plugin_text/sqlite_plugin_text_template_repository.dart';

import 'statistics_template_repository.dart';
import 'statistics_template_tables.dart';

class SqliteStatisticsTemplateRepository
    extends SqlitePluginTextTemplateRepository
    implements StatisticsTemplateRepository {
  const SqliteStatisticsTemplateRepository({
    required super.databaseProvider,
  }) : super(
          tableName: StatisticsTemplateTables.textTemplates,
        );
}
