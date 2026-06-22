import 'package:sqflite/sqflite.dart';

import 'status_monitor_tables.dart';
import 'status_monitor_template_schema.dart';

class StatusMonitorSchema {
  const StatusMonitorSchema();

  Future<void> install(Database database) async {
    await _resetLegacySingletonTables(database);
    await _resetOutdatedHistoryTable(database);
    await _resetOutdatedSettingsTable(database);
    await database.execute('''
      CREATE TABLE IF NOT EXISTS ${StatusMonitorTables.reports} (
        subject_id TEXT PRIMARY KEY,
        source_target_id TEXT,
        source_kind TEXT NOT NULL,
        source_label TEXT NOT NULL,
        generated_at_ms INTEGER NOT NULL,
        payload_json TEXT NOT NULL
      )
    ''');
    await database.execute('''
      CREATE TABLE IF NOT EXISTS ${StatusMonitorTables.history} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        subject_id TEXT NOT NULL,
        source_target_id TEXT,
        source_kind TEXT NOT NULL,
        source_label TEXT NOT NULL,
        component TEXT NOT NULL,
        level TEXT NOT NULL,
        score INTEGER,
        confidence REAL,
        summary TEXT NOT NULL,
        at_ms INTEGER NOT NULL
      )
    ''');
    await database.execute('''
      CREATE INDEX IF NOT EXISTS idx_status_monitor_history_subject_at
      ON ${StatusMonitorTables.history}(subject_id, at_ms DESC)
    ''');
    await database.execute('''
      CREATE INDEX IF NOT EXISTS idx_status_monitor_history_subject_component_at
      ON ${StatusMonitorTables.history}(subject_id, component, at_ms DESC)
    ''');
    await database.execute('''
      CREATE TABLE IF NOT EXISTS ${StatusMonitorTables.probeSamples} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        subject_id TEXT NOT NULL,
        source_target_id TEXT,
        endpoint TEXT NOT NULL,
        level TEXT NOT NULL,
        reachable INTEGER NOT NULL,
        status_code INTEGER,
        elapsed_ms INTEGER NOT NULL,
        at_ms INTEGER NOT NULL
      )
    ''');
    await database.execute('''
      CREATE INDEX IF NOT EXISTS idx_status_monitor_probe_subject_endpoint_at
      ON ${StatusMonitorTables.probeSamples}(subject_id, endpoint, at_ms DESC)
    ''');
    await database.execute('''
      CREATE TABLE IF NOT EXISTS ${StatusMonitorTables.settings} (
        subject_id TEXT PRIMARY KEY,
        persistent_notification_enabled INTEGER NOT NULL DEFAULT 0,
        lock_screen_enabled INTEGER NOT NULL DEFAULT 0,
        low_battery_mode INTEGER NOT NULL DEFAULT 0,
        notification_display_mode TEXT NOT NULL DEFAULT 'full',
        lock_screen_display_mode TEXT NOT NULL DEFAULT 'full',
        updated_at_ms INTEGER NOT NULL
      )
    ''');
    await _ensureColumn(
      database,
      StatusMonitorTables.settings,
      'notification_display_mode',
      "TEXT NOT NULL DEFAULT 'full'",
    );
    await _ensureColumn(
      database,
      StatusMonitorTables.settings,
      'lock_screen_display_mode',
      "TEXT NOT NULL DEFAULT 'full'",
    );
    await database.execute('''
      CREATE TABLE IF NOT EXISTS ${StatusMonitorTables.floatingSettings} (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        mode TEXT NOT NULL DEFAULT 'enabled',
        x INTEGER NOT NULL DEFAULT 24,
        y INTEGER NOT NULL DEFAULT 160,
        collapsed INTEGER NOT NULL DEFAULT 0,
        updated_at_ms INTEGER NOT NULL
      )
    ''');
    await const StatusMonitorTemplateSchema().install(database);
  }

  Future<void> _resetLegacySingletonTables(Database database) async {
    if (await _hasTable(database, StatusMonitorTables.reports) &&
        !await _hasColumn(
            database, StatusMonitorTables.reports, 'subject_id')) {
      await database
          .execute('DROP TABLE IF EXISTS ${StatusMonitorTables.reports}');
    }
    if (await _hasTable(database, StatusMonitorTables.history) &&
        !await _hasColumn(
            database, StatusMonitorTables.history, 'subject_id')) {
      await database
          .execute('DROP TABLE IF EXISTS ${StatusMonitorTables.history}');
    }
    if (await _hasTable(database, StatusMonitorTables.settings) &&
        !await _hasColumn(
            database, StatusMonitorTables.settings, 'subject_id')) {
      await database
          .execute('DROP TABLE IF EXISTS ${StatusMonitorTables.settings}');
    }
  }

  Future<void> _resetOutdatedSettingsTable(Database database) async {
    if (!await _hasTable(database, StatusMonitorTables.settings)) return;
    if (!await _hasColumn(
      database,
      StatusMonitorTables.settings,
      'persistent_notification_enabled',
    )) {
      await database
          .execute('DROP TABLE IF EXISTS ${StatusMonitorTables.settings}');
    }
  }

  Future<void> _resetOutdatedHistoryTable(Database database) async {
    if (!await _hasTable(database, StatusMonitorTables.history)) return;
    final requiredColumns = [
      'source_kind',
      'source_label',
      'score',
      'confidence',
    ];
    for (final column in requiredColumns) {
      if (!await _hasColumn(database, StatusMonitorTables.history, column)) {
        await database
            .execute('DROP TABLE IF EXISTS ${StatusMonitorTables.history}');
        return;
      }
    }
  }

  Future<bool> _hasTable(Database database, String table) async {
    final rows = await database.rawQuery(
      "SELECT name FROM sqlite_master WHERE type = 'table' AND name = ?",
      [table],
    );
    return rows.isNotEmpty;
  }

  Future<bool> _hasColumn(
    Database database,
    String table,
    String column,
  ) async {
    final rows = await database.rawQuery('PRAGMA table_info($table)');
    return rows.any((row) => row['name'] == column);
  }

  Future<void> _ensureColumn(
    Database database,
    String table,
    String column,
    String definition,
  ) async {
    if (!await _hasColumn(database, table, column)) {
      await database
          .execute('ALTER TABLE $table ADD COLUMN $column $definition');
    }
  }
}
