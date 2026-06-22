import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/text/status_text_renderer.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/text/status_text_template_installer.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/data/schema/status_monitor_schema_contributor.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/data/seed/status_monitor_default_text_templates.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/data/sqlite/sqlite_status_monitor_template_repository.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/data/sqlite/status_monitor_tables.dart';
import 'package:smart_xdrip/plugin_platform/schema/plugin_schema_context.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test('status monitor text renderer renders seed templates from facts', () {
    const renderer = StatusTextRenderer();

    final text = renderer.render('status.cgm.hero.summary.v1', const {
      'availableSignals': 3,
      'totalSignals': 4,
      'cv': '31%',
      'jumps': '2',
      'flat': '18m',
    });

    expect(
      text.body,
      '3 of 4 checks passed - CV 31%, 2 jumps, flat 18m.',
    );
  });

  test('status monitor template installer seeds plugin template table',
      () async {
    sqfliteFfiInit();
    final database =
        await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    addTearDown(database.close);

    await const StatusMonitorSchemaContributor().install(
      PluginSchemaContext(
        database: database,
        pluginId: 'explore.statusMonitor',
      ),
    );
    final installer = StatusTextTemplateInstaller(
      repository: SqliteStatusMonitorTemplateRepository(
        databaseProvider: () async => database,
      ),
    );

    await installer.ensureInstalled();
    await installer.ensureInstalled();

    final rows = await database.query(StatusMonitorTables.textTemplates);
    expect(rows, hasLength(StatusMonitorDefaultTextTemplates.all.length));
    expect(
      rows.map((row) => row['template_key']),
      contains('status.nightscout.hero.summary.v1'),
    );
  });
}
