import 'package:sqflite/sqflite.dart';

import 'glance_tables.dart';

class GlanceSchema {
  const GlanceSchema();

  Future<void> install(Database database) async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS ${GlanceTables.widgetConfigs} (
        widget_id INTEGER PRIMARY KEY,
        template TEXT NOT NULL,
        background_style TEXT NOT NULL,
        primary_unit TEXT NOT NULL,
        font_size TEXT NOT NULL,
        graph_range TEXT NOT NULL,
        show_trend_arrow INTEGER NOT NULL,
        show_delta INTEGER NOT NULL,
        show_last_updated INTEGER NOT NULL,
        show_mini_graph INTEGER NOT NULL,
        show_alternate_unit INTEGER NOT NULL,
        tap_action TEXT NOT NULL,
        created_at_ms INTEGER NOT NULL,
        updated_at_ms INTEGER NOT NULL
      )
    ''');
    await database.execute('''
      CREATE TABLE IF NOT EXISTS ${GlanceTables.notificationSettings} (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        enabled INTEGER NOT NULL,
        privacy_mode TEXT NOT NULL,
        lock_screen_mode TEXT NOT NULL DEFAULT 'full_value',
        aod_friendly_enabled INTEGER NOT NULL DEFAULT 1,
        notification_display_mode TEXT NOT NULL DEFAULT 'full_value',
        external_surfaces_defaulted INTEGER NOT NULL DEFAULT 0,
        quick_actions_enabled INTEGER NOT NULL,
        low_battery_mode INTEGER NOT NULL,
        updated_at_ms INTEGER NOT NULL
      )
    ''');
    await _addColumnIfMissing(
      database,
      GlanceTables.notificationSettings,
      'lock_screen_mode',
      "TEXT NOT NULL DEFAULT 'full_value'",
    );
    await _addColumnIfMissing(
      database,
      GlanceTables.notificationSettings,
      'aod_friendly_enabled',
      'INTEGER NOT NULL DEFAULT 1',
    );
    await _addColumnIfMissing(
      database,
      GlanceTables.notificationSettings,
      'notification_display_mode',
      "TEXT NOT NULL DEFAULT 'full_value'",
    );
    await _addColumnIfMissing(
      database,
      GlanceTables.notificationSettings,
      'external_surfaces_defaulted',
      'INTEGER NOT NULL DEFAULT 0',
    );
    await database.execute('''
      CREATE TABLE IF NOT EXISTS ${GlanceTables.floatingSettings} (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        mode TEXT NOT NULL,
        display_style TEXT NOT NULL,
        size_preset TEXT NOT NULL DEFAULT 'medium',
        form_factor TEXT NOT NULL DEFAULT 'pill',
        preset_source TEXT NOT NULL DEFAULT 'automatic',
        position_x REAL NOT NULL,
        position_y REAL NOT NULL,
        collapsed INTEGER NOT NULL,
        updated_at_ms INTEGER NOT NULL
      )
    ''');
    await _addColumnIfMissing(
      database,
      GlanceTables.floatingSettings,
      'size_preset',
      "TEXT NOT NULL DEFAULT 'medium'",
    );
    await _addColumnIfMissing(
      database,
      GlanceTables.floatingSettings,
      'form_factor',
      "TEXT NOT NULL DEFAULT 'pill'",
    );
    await _addColumnIfMissing(
      database,
      GlanceTables.floatingSettings,
      'preset_source',
      "TEXT NOT NULL DEFAULT 'automatic'",
    );
  }

  Future<void> _addColumnIfMissing(
    Database database,
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
