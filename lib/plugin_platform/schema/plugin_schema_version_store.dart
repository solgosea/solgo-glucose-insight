import 'package:sqflite/sqflite.dart';

class PluginSchemaVersionStore {
  static const tableName = 'plugin_schema_versions';

  const PluginSchemaVersionStore();

  Future<void> ensureInitialized(Database database) async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        plugin_id TEXT PRIMARY KEY,
        schema_version INTEGER NOT NULL,
        installed_at_ms INTEGER NOT NULL,
        updated_at_ms INTEGER NOT NULL
      )
    ''');
  }

  Future<int> versionFor(Database database, String pluginId) async {
    final rows = await database.query(
      tableName,
      columns: ['schema_version'],
      where: 'plugin_id = ?',
      whereArgs: [pluginId],
      limit: 1,
    );
    if (rows.isEmpty) return 0;
    return (rows.first['schema_version'] as num).toInt();
  }

  Future<void> markInstalled(
    Database database, {
    required String pluginId,
    required int schemaVersion,
  }) async {
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    await database.insert(tableName, {
      'plugin_id': pluginId,
      'schema_version': schemaVersion,
      'installed_at_ms': nowMs,
      'updated_at_ms': nowMs,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
