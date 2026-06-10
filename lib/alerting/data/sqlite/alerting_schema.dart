import 'package:sqflite/sqflite.dart';

import '../../alerting_tables.dart';

class AlertingSchema {
  const AlertingSchema();

  Future<void> create(Database database) async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS ${AlertingTables.queueMessages} (
        id TEXT PRIMARY KEY,
        dedupe_key TEXT NOT NULL UNIQUE,
        message_type TEXT NOT NULL,
        source TEXT NOT NULL,
        target_plugin_id TEXT,
        target_id TEXT,
        subject_id TEXT,
        alert_event_id TEXT,
        alert_type TEXT,
        canonical_source_key TEXT,
        dedupe_scope TEXT,
        source_priority INTEGER NOT NULL DEFAULT 0,
        priority TEXT NOT NULL,
        payload_json TEXT NOT NULL,
        state TEXT NOT NULL,
        attempt_count INTEGER NOT NULL DEFAULT 0,
        available_at_ms INTEGER NOT NULL,
        locked_at_ms INTEGER,
        processed_at_ms INTEGER,
        failed_reason TEXT,
        created_at_ms INTEGER NOT NULL,
        updated_at_ms INTEGER NOT NULL
      )
    ''');
    await database.execute('''
      CREATE INDEX IF NOT EXISTS idx_app_alert_queue_state_available
      ON ${AlertingTables.queueMessages}(state, available_at_ms)
    ''');
    await database.execute('''
      CREATE INDEX IF NOT EXISTS idx_app_alert_queue_plugin_target
      ON ${AlertingTables.queueMessages}(target_plugin_id, target_id, created_at_ms DESC)
    ''');
    await database.execute('''
      CREATE INDEX IF NOT EXISTS idx_app_alert_queue_alert_event
      ON ${AlertingTables.queueMessages}(alert_event_id)
    ''');
    await _addColumnIfMissing(
      database,
      AlertingTables.queueMessages,
      'canonical_source_key',
      'TEXT',
    );
    await _addColumnIfMissing(
      database,
      AlertingTables.queueMessages,
      'dedupe_scope',
      'TEXT',
    );
    await _addColumnIfMissing(
      database,
      AlertingTables.queueMessages,
      'source_priority',
      'INTEGER NOT NULL DEFAULT 0',
    );

    await database.execute('''
      CREATE TABLE IF NOT EXISTS ${AlertingTables.events} (
        id TEXT PRIMARY KEY,
        source TEXT NOT NULL,
        source_event_id TEXT,
        category TEXT NOT NULL,
        level TEXT NOT NULL,
        state TEXT NOT NULL,
        title TEXT NOT NULL,
        body TEXT NOT NULL,
        payload_json TEXT,
        occurred_at TEXT NOT NULL,
        received_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
    await database.execute('''
      CREATE UNIQUE INDEX IF NOT EXISTS idx_app_alert_events_source_event
      ON ${AlertingTables.events}(source, source_event_id)
      WHERE source_event_id IS NOT NULL
    ''');
    await database.execute('''
      CREATE INDEX IF NOT EXISTS idx_app_alert_events_state_time
      ON ${AlertingTables.events}(state, occurred_at DESC)
    ''');

    await database.execute('''
      CREATE TABLE IF NOT EXISTS ${AlertingTables.strategyConfigs} (
        strategy_key TEXT PRIMARY KEY,
        enabled INTEGER NOT NULL,
        config_json TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    await database.execute('''
      CREATE TABLE IF NOT EXISTS ${AlertingTables.deliveryPlans} (
        id TEXT PRIMARY KEY,
        alert_event_id TEXT NOT NULL,
        level TEXT NOT NULL,
        channels_json TEXT NOT NULL,
        state TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
    await database.execute('''
      CREATE INDEX IF NOT EXISTS idx_app_alert_delivery_plans_event
      ON ${AlertingTables.deliveryPlans}(alert_event_id)
    ''');

    await database.execute('''
      CREATE TABLE IF NOT EXISTS ${AlertingTables.deliveryLogs} (
        id TEXT PRIMARY KEY,
        alert_event_id TEXT NOT NULL,
        plan_id TEXT,
        channel TEXT NOT NULL,
        strategy_key TEXT NOT NULL,
        status TEXT NOT NULL,
        message TEXT,
        result_json TEXT,
        attempted_at TEXT NOT NULL,
        completed_at TEXT
      )
    ''');
    await database.execute('''
      CREATE INDEX IF NOT EXISTS idx_app_alert_delivery_logs_event
      ON ${AlertingTables.deliveryLogs}(alert_event_id, attempted_at DESC)
    ''');

    await database.execute('''
      CREATE TABLE IF NOT EXISTS ${AlertingTables.actionLogs} (
        id TEXT PRIMARY KEY,
        alert_event_id TEXT NOT NULL,
        action TEXT NOT NULL,
        actor TEXT NOT NULL,
        note TEXT,
        created_at TEXT NOT NULL
      )
    ''');
    await database.execute('''
      CREATE INDEX IF NOT EXISTS idx_app_alert_action_logs_event
      ON ${AlertingTables.actionLogs}(alert_event_id, created_at DESC)
    ''');

    await database.execute('''
      CREATE TABLE IF NOT EXISTS ${AlertingTables.snoozeRules} (
        id TEXT PRIMARY KEY,
        alert_event_id TEXT,
        target_id TEXT,
        alert_type TEXT,
        source TEXT,
        category TEXT,
        level TEXT,
        snoozed_until TEXT NOT NULL,
        reason TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
    await database.execute('''
      CREATE INDEX IF NOT EXISTS idx_app_alert_snooze_rules_until
      ON ${AlertingTables.snoozeRules}(snoozed_until)
    ''');
    await _addColumnIfMissing(
      database,
      AlertingTables.snoozeRules,
      'target_id',
      'TEXT',
    );
    await _addColumnIfMissing(
      database,
      AlertingTables.snoozeRules,
      'alert_type',
      'TEXT',
    );
    await database.execute('''
      CREATE INDEX IF NOT EXISTS idx_app_alert_snooze_rules_target_type
      ON ${AlertingTables.snoozeRules}(target_id, alert_type, snoozed_until)
    ''');

    await database.execute('''
      CREATE TABLE IF NOT EXISTS ${AlertingTables.resources} (
        id TEXT PRIMARY KEY,
        resource_type TEXT NOT NULL,
        resource_key TEXT NOT NULL,
        display_name TEXT NOT NULL,
        uri TEXT NOT NULL,
        metadata_json TEXT,
        enabled INTEGER NOT NULL DEFAULT 1,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        UNIQUE(resource_type, resource_key)
      )
    ''');

    await database.execute('''
      CREATE TABLE IF NOT EXISTS ${AlertingTables.ruleSets} (
        id TEXT PRIMARY KEY,
        rule_set_key TEXT NOT NULL,
        scope TEXT NOT NULL,
        subject_id TEXT,
        display_name TEXT NOT NULL,
        enabled INTEGER NOT NULL,
        metadata_json TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        UNIQUE(rule_set_key, subject_id)
      )
    ''');
    await database.execute('''
      CREATE INDEX IF NOT EXISTS idx_app_alert_rule_sets_key
      ON ${AlertingTables.ruleSets}(rule_set_key, subject_id)
    ''');

    await database.execute('''
      CREATE TABLE IF NOT EXISTS ${AlertingTables.rules} (
        id TEXT PRIMARY KEY,
        rule_set_id TEXT NOT NULL,
        category TEXT NOT NULL,
        enabled INTEGER NOT NULL,
        comparator TEXT NOT NULL,
        threshold_value REAL,
        threshold_unit TEXT,
        level TEXT NOT NULL,
        channels_json TEXT NOT NULL,
        sound_policy_json TEXT,
        repeat_minutes INTEGER NOT NULL,
        priority INTEGER NOT NULL,
        metadata_json TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        UNIQUE(rule_set_id, category)
      )
    ''');
    await database.execute('''
      CREATE INDEX IF NOT EXISTS idx_app_alert_rules_set_enabled
      ON ${AlertingTables.rules}(rule_set_id, enabled)
    ''');
    await database.execute('''
      CREATE INDEX IF NOT EXISTS idx_app_alert_rules_category_enabled
      ON ${AlertingTables.rules}(category, enabled)
    ''');
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
