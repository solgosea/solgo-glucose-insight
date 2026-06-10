import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugin_platform/schema/plugin_schema_context.dart';
import 'package:smart_xdrip/plugin_platform/schema/plugin_schema_contributor.dart';
import 'package:smart_xdrip/plugin_platform/schema/plugin_schema_manager.dart';
import 'package:smart_xdrip/plugin_platform/schema/plugin_schema_registry.dart';
import 'package:smart_xdrip/plugin_platform/schema/plugin_schema_version_store.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late Database database;

  setUp(() async {
    sqfliteFfiInit();
    database = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
  });

  tearDown(() async {
    await database.close();
  });

  test('installs registered plugin schemas and records versions', () async {
    final registry =
        PluginSchemaRegistry()..register(const _TestSchemaContributor());
    final manager = PluginSchemaManager(
      databaseProvider: () async => database,
      registry: registry,
    );

    await manager.ensureInstalled();

    final tables = await database.rawQuery(
      "SELECT name FROM sqlite_master WHERE type = 'table'",
    );
    final names = tables.map((row) => row['name']).toSet();
    expect(names, contains('test_plugin_items'));
    expect(names, contains(PluginSchemaVersionStore.tableName));

    final versions = await database.query(
      PluginSchemaVersionStore.tableName,
      where: 'plugin_id = ?',
      whereArgs: ['test.plugin'],
    );
    expect(versions, hasLength(1));
    expect(versions.first['schema_version'], 1);
  });

  test('is idempotent when schema is already current', () async {
    final contributor = _CountingSchemaContributor();
    final registry = PluginSchemaRegistry()..register(contributor);
    final manager = PluginSchemaManager(
      databaseProvider: () async => database,
      registry: registry,
    );

    await manager.ensureInstalled();
    await manager.ensureInstalled();

    expect(contributor.installCount, 1);
  });
}

class _TestSchemaContributor extends PluginSchemaContributor {
  const _TestSchemaContributor();

  @override
  String get pluginId => 'test.plugin';

  @override
  int get schemaVersion => 1;

  @override
  Future<void> install(PluginSchemaContext context) {
    return context.database.execute('''
      CREATE TABLE IF NOT EXISTS test_plugin_items (
        id TEXT PRIMARY KEY
      )
    ''');
  }
}

class _CountingSchemaContributor extends PluginSchemaContributor {
  int installCount = 0;

  @override
  String get pluginId => 'counting.plugin';

  @override
  int get schemaVersion => 1;

  @override
  Future<void> install(PluginSchemaContext context) async {
    installCount += 1;
    await context.database.execute('''
      CREATE TABLE IF NOT EXISTS counting_plugin_items (
        id TEXT PRIMARY KEY
      )
    ''');
  }
}
