import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:smart_xdrip/plugins/glance/data/sqlite/glance_schema.dart';
import 'package:smart_xdrip/plugins/glance/data/sqlite/glance_tables.dart';

void main() {
  sqfliteFfiInit();

  test('installs plugin tables idempotently', () async {
    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    addTearDown(db.close);

    const schema = GlanceSchema();
    await schema.install(db);
    await schema.install(db);

    final tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type = 'table' AND name LIKE 'glance_%'",
    );
    final names = tables.map((row) => row['name']).toSet();

    expect(names, contains(GlanceTables.widgetConfigs));
    expect(names, contains(GlanceTables.notificationSettings));

    final floatingColumns = await db.rawQuery(
      'PRAGMA table_info(${GlanceTables.floatingSettings})',
    );
    final floatingColumnNames =
        floatingColumns.map((row) => row['name']).toSet();
    expect(floatingColumnNames, contains('size_preset'));
    expect(floatingColumnNames, contains('form_factor'));
    expect(floatingColumnNames, contains('preset_source'));
  });
}
