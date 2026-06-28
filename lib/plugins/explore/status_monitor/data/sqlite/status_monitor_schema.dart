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
        probe_id TEXT,
        suite_id TEXT,
        run_mode TEXT,
        category TEXT,
        level TEXT NOT NULL,
        reachable INTEGER NOT NULL,
        status_code INTEGER,
        elapsed_ms INTEGER NOT NULL,
        confidence REAL,
        summary TEXT,
        payload_json TEXT,
        at_ms INTEGER NOT NULL
      )
    ''');
    await _ensureColumn(
      database,
      StatusMonitorTables.probeSamples,
      'probe_id',
      'TEXT',
    );
    await _ensureColumn(
      database,
      StatusMonitorTables.probeSamples,
      'suite_id',
      'TEXT',
    );
    await _ensureColumn(
      database,
      StatusMonitorTables.probeSamples,
      'run_mode',
      'TEXT',
    );
    await _ensureColumn(
      database,
      StatusMonitorTables.probeSamples,
      'category',
      'TEXT',
    );
    await _ensureColumn(
      database,
      StatusMonitorTables.probeSamples,
      'confidence',
      'REAL',
    );
    await _ensureColumn(
      database,
      StatusMonitorTables.probeSamples,
      'summary',
      'TEXT',
    );
    await _ensureColumn(
      database,
      StatusMonitorTables.probeSamples,
      'payload_json',
      'TEXT',
    );
    await database.execute('''
      CREATE INDEX IF NOT EXISTS idx_status_monitor_probe_subject_endpoint_at
      ON ${StatusMonitorTables.probeSamples}(subject_id, endpoint, at_ms DESC)
    ''');
    await database.execute('''
      CREATE TABLE IF NOT EXISTS ${StatusMonitorTables.probeCatalogSuites} (
        suite_id TEXT PRIMARY KEY,
        kind TEXT NOT NULL,
        title_key TEXT NOT NULL,
        description_key TEXT NOT NULL,
        icon_key TEXT,
        role TEXT NOT NULL DEFAULT 'core',
        score_scope TEXT NOT NULL DEFAULT 'included',
        priority INTEGER NOT NULL,
        enabled INTEGER NOT NULL
      )
    ''');
    await _ensureColumn(
      database,
      StatusMonitorTables.probeCatalogSuites,
      'role',
      "TEXT NOT NULL DEFAULT 'core'",
    );
    await _ensureColumn(
      database,
      StatusMonitorTables.probeCatalogSuites,
      'score_scope',
      "TEXT NOT NULL DEFAULT 'included'",
    );
    await database.execute('''
      CREATE TABLE IF NOT EXISTS ${StatusMonitorTables.probeCatalogProbes} (
        probe_id TEXT PRIMARY KEY,
        suite_id TEXT NOT NULL,
        driver_id TEXT NOT NULL,
        title_key TEXT NOT NULL,
        description_key TEXT NOT NULL,
        icon_key TEXT,
        guide_route TEXT,
        role TEXT NOT NULL DEFAULT 'core',
        score_scope TEXT NOT NULL DEFAULT 'included',
        required INTEGER NOT NULL,
        activation_probe INTEGER NOT NULL DEFAULT 0,
        priority INTEGER NOT NULL,
        enabled INTEGER NOT NULL
      )
    ''');
    await _ensureColumn(
      database,
      StatusMonitorTables.probeCatalogProbes,
      'role',
      "TEXT NOT NULL DEFAULT 'core'",
    );
    await _ensureColumn(
      database,
      StatusMonitorTables.probeCatalogProbes,
      'score_scope',
      "TEXT NOT NULL DEFAULT 'included'",
    );
    await _ensureColumn(
      database,
      StatusMonitorTables.probeCatalogProbes,
      'activation_probe',
      'INTEGER NOT NULL DEFAULT 0',
    );
    await database.execute('''
      CREATE INDEX IF NOT EXISTS idx_status_probe_catalog_probes_suite
      ON ${StatusMonitorTables.probeCatalogProbes}(suite_id, priority)
    ''');
    await database.execute('''
      CREATE TABLE IF NOT EXISTS ${StatusMonitorTables.probeScenarios} (
        scenario_id TEXT PRIMARY KEY,
        title_key TEXT NOT NULL,
        description_key TEXT NOT NULL,
        enabled INTEGER NOT NULL
      )
    ''');
    await database.execute('''
      CREATE TABLE IF NOT EXISTS ${StatusMonitorTables.probeScenarioItems} (
        scenario_id TEXT NOT NULL,
        suite_id TEXT NOT NULL,
        probe_id TEXT,
        section_id TEXT,
        order_index INTEGER NOT NULL,
        enabled INTEGER NOT NULL,
        weight REAL NOT NULL DEFAULT 1.0,
        score_scope TEXT,
        hard_gate INTEGER NOT NULL DEFAULT 0,
        activation_probe INTEGER NOT NULL DEFAULT 0,
        score_cap INTEGER,
        PRIMARY KEY (scenario_id, suite_id, probe_id)
      )
    ''');
    await _ensureColumn(
      database,
      StatusMonitorTables.probeScenarioItems,
      'section_id',
      'TEXT',
    );
    await _ensureColumn(
      database,
      StatusMonitorTables.probeScenarioItems,
      'weight',
      'REAL NOT NULL DEFAULT 1.0',
    );
    await _ensureColumn(
      database,
      StatusMonitorTables.probeScenarioItems,
      'score_scope',
      'TEXT',
    );
    await _ensureColumn(
      database,
      StatusMonitorTables.probeScenarioItems,
      'hard_gate',
      'INTEGER NOT NULL DEFAULT 0',
    );
    await _ensureColumn(
      database,
      StatusMonitorTables.probeScenarioItems,
      'activation_probe',
      'INTEGER NOT NULL DEFAULT 0',
    );
    await _ensureColumn(
      database,
      StatusMonitorTables.probeScenarioItems,
      'score_cap',
      'INTEGER',
    );
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
