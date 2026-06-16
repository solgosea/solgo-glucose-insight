import 'package:sqflite/sqflite.dart';

class PluginTextTemplateSchema {
  final String tableName;

  const PluginTextTemplateSchema(this.tableName);

  Future<void> install(Database database) async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        template_key TEXT PRIMARY KEY,
        slot TEXT NOT NULL,
        type TEXT NOT NULL,
        locale TEXT NOT NULL DEFAULT 'en',
        version INTEGER NOT NULL DEFAULT 1,
        title_template TEXT,
        body_template TEXT NOT NULL,
        footer_template TEXT,
        required_facts_json TEXT,
        enabled INTEGER NOT NULL DEFAULT 1,
        priority INTEGER NOT NULL DEFAULT 100,
        updated_at_ms INTEGER NOT NULL
      )
    ''');
    await database.execute('''
      CREATE INDEX IF NOT EXISTS idx_${tableName}_lookup
      ON $tableName(slot, type, locale, enabled, priority)
    ''');
  }
}
