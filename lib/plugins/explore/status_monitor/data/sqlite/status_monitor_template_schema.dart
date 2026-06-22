import 'package:sqflite/sqflite.dart';

import 'status_monitor_tables.dart';

class StatusMonitorTemplateSchema {
  const StatusMonitorTemplateSchema();

  Future<void> install(Database database) async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS ${StatusMonitorTables.textTemplates} (
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
      CREATE INDEX IF NOT EXISTS idx_status_monitor_text_templates_lookup
      ON ${StatusMonitorTables.textTemplates}(slot, type, locale, enabled, priority)
    ''');
  }
}
