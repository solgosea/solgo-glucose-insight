import 'package:sqflite/sqflite.dart';

class PluginSchemaContext {
  final Database database;
  final String pluginId;

  const PluginSchemaContext({required this.database, required this.pluginId});

  Future<void> addColumnIfMissing(
    String table,
    String column,
    String definition,
  ) async {
    final rows = await database.rawQuery('PRAGMA table_info($table)');
    final exists = rows.any((row) => row['name'] == column);
    if (!exists) {
      await database.execute(
        'ALTER TABLE $table ADD COLUMN $column $definition',
      );
    }
  }
}
