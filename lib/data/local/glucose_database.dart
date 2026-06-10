import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../domain/analysis/analysis_module_code.dart';
import '../../domain/analysis/daily_glucose_summary.dart';
import '../../domain/analysis/json_snapshot.dart';
import '../../domain/analysis/period_glucose_summary.dart';
import '../../domain/entities/glucose_event.dart';
import '../../domain/entities/glucose_gap.dart';
import '../../domain/entities/glucose_reading.dart';
import '../../domain/entities/source_sync_state.dart';
import '../../domain/glucose_etl/canonical_glucose_candidate.dart';
import '../../domain/glucose_etl/raw_glucose_reading.dart';
import '../../domain/insight/insight_template.dart';
import '../../domain/insight/narrative_insight.dart';
import '../../domain/subject/glucose_subject.dart';
import 'dao/events_dao.dart';
import 'dao/gaps_dao.dart';
import 'dao/insights_dao.dart';
import 'dao/raw_readings_dao.dart';
import 'dao/readings_dao.dart';
import 'dao/snapshots_dao.dart';
import 'dao/source_state_dao.dart';
import 'dao/stats_dao.dart';
import 'glucose_tables.dart';

class GlucoseDatabase {
  static const _dbName = 'smart_xdrip.db';
  static const _dbVersion = 8;
  final DatabaseFactory? databaseFactoryOverride;
  final String? databasePathOverride;

  static const rawReadingsTable = GlucoseTables.rawReadings;
  static const readingsTable = GlucoseTables.readings;
  static const eventsTable = GlucoseTables.events;
  static const dailyStatsTable = GlucoseTables.dailyStats;
  static const periodStatsTable = GlucoseTables.periodStats;
  static const agpSnapshotsTable = GlucoseTables.agpSnapshots;
  static const patternSnapshotsTable = GlucoseTables.patternSnapshots;
  static const insightTemplatesTable = GlucoseTables.insightTemplates;
  static const insightTemplateVariablesTable =
      GlucoseTables.insightTemplateVariables;
  static const generatedInsightsTable = GlucoseTables.generatedInsights;
  static const sourceStateTable = GlucoseTables.sourceState;
  static const glucoseGapsTable = GlucoseTables.glucoseGaps;

  Database? _db;

  GlucoseDatabase({this.databaseFactoryOverride, this.databasePathOverride});

  late final RawReadingsDao rawReadings = RawReadingsDao(() => db);
  late final ReadingsDao readings = ReadingsDao(() => db);
  late final EventsDao events = EventsDao(() => db);
  late final StatsDao stats = StatsDao(() => db);
  late final SnapshotsDao snapshots = SnapshotsDao(() => db);
  late final InsightsDao insights = InsightsDao(() => db);
  late final GapsDao gaps = GapsDao(() => db);
  late final SourceStateDao sourceState = SourceStateDao(() => db);

  Future<Database> get db async {
    if (_db != null) return _db!;
    final path = databasePathOverride ?? await _defaultDatabasePath();
    final options = OpenDatabaseOptions(
      version: _dbVersion,
      onCreate: (database, _) async {
        await _createV1(database);
        await _createV2(database);
        await _createV3(database);
        await _createV4(database);
        await _createV5(database);
        await _createV6(database);
        await _createV7(database);
        await _createV8(database);
      },
      onUpgrade: (database, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await _createV2(database);
        }
        if (oldVersion < 3) {
          await _createV3(database);
        }
        if (oldVersion < 4) {
          await _createV4(database);
        }
        if (oldVersion < 5) {
          await _createV5(database);
        }
        if (oldVersion < 6) {
          await _createV6(database);
        }
        if (oldVersion < 7) {
          await _createV7(database);
        }
        if (oldVersion < 8) {
          await _createV8(database);
        }
      },
    );
    _db =
        databaseFactoryOverride == null
            ? await openDatabase(
              path,
              version: _dbVersion,
              onCreate: options.onCreate,
              onUpgrade: options.onUpgrade,
            )
            : await databaseFactoryOverride!.openDatabase(
              path,
              options: options,
            );
    return _db!;
  }

  Future<String> _defaultDatabasePath() async {
    final dir = await getApplicationDocumentsDirectory();
    return p.join(dir.path, _dbName);
  }

  Future<void> close() async {
    final database = _db;
    _db = null;
    await database?.close();
  }

  Future<void> _createV1(Database database) async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS $readingsTable (
        subject_id TEXT NOT NULL DEFAULT '${GlucoseSubject.selfId}',
        ts_ms INTEGER NOT NULL,
        value REAL NOT NULL,
        rate_per_min REAL,
        source TEXT,
        source_priority INTEGER DEFAULT 100,
        raw_id TEXT,
        updated_at_ms INTEGER,
        PRIMARY KEY(subject_id, ts_ms)
      )
    ''');
    await database.execute(
      'CREATE INDEX IF NOT EXISTS idx_readings_ts '
      'ON $readingsTable(subject_id, ts_ms DESC)',
    );
  }

  Future<void> _createV2(Database database) async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS $eventsTable (
        id TEXT NOT NULL,
        subject_id TEXT NOT NULL DEFAULT '${GlucoseSubject.selfId}',
        event_type TEXT NOT NULL,
        start_ts_ms INTEGER NOT NULL,
        end_ts_ms INTEGER,
        value REAL NOT NULL,
        peak_or_nadir REAL,
        rate_per_min REAL,
        low_severity TEXT,
        is_nocturnal INTEGER NOT NULL DEFAULT 0,
        area_out_of_range REAL,
        created_at_ms INTEGER NOT NULL,
        PRIMARY KEY(subject_id, id)
      )
    ''');
    await database.execute(
      'CREATE INDEX IF NOT EXISTS idx_events_time '
      'ON $eventsTable(subject_id, start_ts_ms DESC)',
    );

    await database.execute('''
      CREATE TABLE IF NOT EXISTS $dailyStatsTable (
        subject_id TEXT NOT NULL DEFAULT '${GlucoseSubject.selfId}',
        day TEXT NOT NULL,
        reading_count INTEGER NOT NULL,
        tir REAL NOT NULL,
        tar REAL NOT NULL,
        tbr REAL NOT NULL,
        mean REAL NOT NULL,
        cv REAL NOT NULL,
        min_value REAL NOT NULL,
        max_value REAL NOT NULL,
        first_reading_value REAL NOT NULL,
        updated_at_ms INTEGER NOT NULL,
        PRIMARY KEY(subject_id, day)
      )
    ''');

    await database.execute('''
      CREATE TABLE IF NOT EXISTS $periodStatsTable (
        subject_id TEXT NOT NULL DEFAULT '${GlucoseSubject.selfId}',
        period_key TEXT NOT NULL,
        label TEXT NOT NULL,
        reading_count INTEGER NOT NULL,
        tir REAL NOT NULL,
        tar REAL NOT NULL,
        tbr REAL NOT NULL,
        mean REAL NOT NULL,
        cv REAL NOT NULL,
        min_value REAL NOT NULL,
        max_value REAL NOT NULL,
        updated_at_ms INTEGER NOT NULL,
        PRIMARY KEY(subject_id, period_key)
      )
    ''');

    await database.execute('''
      CREATE TABLE IF NOT EXISTS $agpSnapshotsTable (
        subject_id TEXT NOT NULL DEFAULT '${GlucoseSubject.selfId}',
        snapshot_key TEXT NOT NULL,
        window_start_ms INTEGER NOT NULL,
        window_end_ms INTEGER NOT NULL,
        payload_json TEXT NOT NULL,
        updated_at_ms INTEGER NOT NULL,
        PRIMARY KEY(subject_id, snapshot_key)
      )
    ''');

    await database.execute('''
      CREATE TABLE IF NOT EXISTS $patternSnapshotsTable (
        subject_id TEXT NOT NULL DEFAULT '${GlucoseSubject.selfId}',
        snapshot_key TEXT NOT NULL,
        module_code TEXT NOT NULL,
        window_start_ms INTEGER NOT NULL,
        window_end_ms INTEGER NOT NULL,
        payload_json TEXT NOT NULL,
        updated_at_ms INTEGER NOT NULL,
        PRIMARY KEY(subject_id, snapshot_key)
      )
    ''');

    await database.execute('''
      CREATE TABLE IF NOT EXISTS $insightTemplatesTable (
        code TEXT PRIMARY KEY,
        module_code TEXT NOT NULL,
        title TEXT NOT NULL,
        body_template TEXT NOT NULL,
        priority INTEGER NOT NULL DEFAULT 100,
        enabled INTEGER NOT NULL DEFAULT 1,
        updated_at_ms INTEGER NOT NULL
      )
    ''');
    await database.execute(
      'CREATE INDEX IF NOT EXISTS idx_templates_module '
      'ON $insightTemplatesTable(module_code, enabled, priority)',
    );

    await database.execute('''
      CREATE TABLE IF NOT EXISTS $generatedInsightsTable (
        id TEXT NOT NULL,
        subject_id TEXT NOT NULL DEFAULT '${GlucoseSubject.selfId}',
        module_code TEXT NOT NULL,
        template_code TEXT NOT NULL,
        title TEXT NOT NULL,
        body TEXT NOT NULL,
        generated_at_ms INTEGER NOT NULL,
        PRIMARY KEY(subject_id, id)
      )
    ''');
    await database.execute(
      'CREATE INDEX IF NOT EXISTS idx_generated_module '
      'ON $generatedInsightsTable(module_code, generated_at_ms DESC)',
    );

    await database.execute('''
      CREATE TABLE IF NOT EXISTS $sourceStateTable (
        subject_id TEXT NOT NULL DEFAULT '${GlucoseSubject.selfId}',
        source_key TEXT NOT NULL,
        last_success_at_ms INTEGER,
        last_attempt_at_ms INTEGER,
        last_cursor TEXT,
        last_error TEXT,
        updated_at_ms INTEGER NOT NULL,
        PRIMARY KEY(subject_id, source_key)
      )
    ''');

    await database.execute('''
      CREATE TABLE IF NOT EXISTS $glucoseGapsTable (
        id TEXT NOT NULL,
        subject_id TEXT NOT NULL DEFAULT '${GlucoseSubject.selfId}',
        start_ts_ms INTEGER NOT NULL,
        end_ts_ms INTEGER NOT NULL,
        duration_minutes INTEGER NOT NULL,
        source TEXT,
        created_at_ms INTEGER NOT NULL,
        PRIMARY KEY(subject_id, id)
      )
    ''');
    await database.execute(
      'CREATE INDEX IF NOT EXISTS idx_gaps_start '
      'ON $glucoseGapsTable(subject_id, start_ts_ms DESC)',
    );
  }

  Future<void> _createV3(Database database) async {
    await database.execute('DROP TABLE IF EXISTS $insightTemplatesTable');
    await database.execute(
      'DROP TABLE IF EXISTS $insightTemplateVariablesTable',
    );
    await database.execute('DROP TABLE IF EXISTS $generatedInsightsTable');

    await database.execute('''
      CREATE TABLE $insightTemplatesTable (
        code TEXT PRIMARY KEY,
        module_code TEXT NOT NULL,
        slot_code TEXT NOT NULL,
        insight_type TEXT NOT NULL,
        locale TEXT NOT NULL DEFAULT 'en',
        version INTEGER NOT NULL DEFAULT 1,
        enabled INTEGER NOT NULL DEFAULT 1,
        priority INTEGER NOT NULL DEFAULT 100,
        icon_key TEXT,
        tone TEXT,
        title_template TEXT,
        eyebrow_template TEXT,
        body_template TEXT NOT NULL,
        footer_template TEXT,
        required_facts_json TEXT,
        fallback_code TEXT,
        updated_at_ms INTEGER NOT NULL
      )
    ''');
    await database.execute(
      'CREATE INDEX idx_templates_module '
      'ON $insightTemplatesTable(module_code, slot_code, insight_type, locale, enabled, priority)',
    );

    await database.execute('''
      CREATE TABLE $insightTemplateVariablesTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        template_code TEXT NOT NULL,
        variable_key TEXT NOT NULL,
        value_type TEXT NOT NULL,
        format_rule TEXT,
        required INTEGER NOT NULL DEFAULT 1,
        description TEXT,
        UNIQUE(template_code, variable_key)
      )
    ''');
    await database.execute(
      'CREATE INDEX idx_template_variables_code '
      'ON $insightTemplateVariablesTable(template_code)',
    );

    await database.execute('''
      CREATE TABLE $generatedInsightsTable (
        id TEXT NOT NULL,
        subject_id TEXT NOT NULL DEFAULT '${GlucoseSubject.selfId}',
        module_code TEXT NOT NULL,
        slot_code TEXT NOT NULL,
        insight_type TEXT NOT NULL,
        template_code TEXT NOT NULL,
        template_version INTEGER NOT NULL,
        title TEXT,
        eyebrow TEXT,
        body TEXT NOT NULL,
        footer TEXT,
        facts_json TEXT NOT NULL,
        generated_at_ms INTEGER NOT NULL,
        PRIMARY KEY(subject_id, id)
      )
    ''');

    await database.execute(
      'CREATE INDEX idx_generated_slot '
      'ON $generatedInsightsTable(subject_id, module_code, slot_code, generated_at_ms DESC)',
    );
  }

  Future<void> _createV4(Database database) async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS $rawReadingsTable (
        id TEXT NOT NULL,
        subject_id TEXT NOT NULL DEFAULT '${GlucoseSubject.selfId}',
        source TEXT NOT NULL,
        source_record_id TEXT NOT NULL,
        ts_ms INTEGER NOT NULL,
        bucket_ms INTEGER NOT NULL,
        value REAL NOT NULL,
        rate_per_min REAL,
        received_at_ms INTEGER NOT NULL,
        payload_json TEXT,
        PRIMARY KEY(subject_id, id),
        UNIQUE(subject_id, source, source_record_id),
        UNIQUE(subject_id, source, ts_ms, value)
      )
    ''');
    await database.execute(
      'CREATE INDEX IF NOT EXISTS idx_raw_readings_bucket '
      'ON $rawReadingsTable(subject_id, bucket_ms)',
    );
    await database.execute(
      'CREATE INDEX IF NOT EXISTS idx_raw_readings_source_ts '
      'ON $rawReadingsTable(subject_id, source, ts_ms DESC)',
    );
    await _addColumnIfMissing(
      database,
      readingsTable,
      'source_priority',
      'INTEGER DEFAULT 100',
    );
    await _addColumnIfMissing(database, readingsTable, 'raw_id', 'TEXT');
    await _addColumnIfMissing(
      database,
      readingsTable,
      'updated_at_ms',
      'INTEGER',
    );
  }

  Future<void> _createV5(Database database) async {
    // Plugin-owned schemas are installed by PluginSchemaManager.
  }

  Future<void> _createV6(Database database) async {
    if (await _hasColumn(database, readingsTable, 'subject_id') &&
        await _hasColumn(database, rawReadingsTable, 'subject_id') &&
        await _hasColumn(database, eventsTable, 'subject_id') &&
        await _hasColumn(database, dailyStatsTable, 'subject_id') &&
        await _hasColumn(database, periodStatsTable, 'subject_id') &&
        await _hasColumn(database, agpSnapshotsTable, 'subject_id') &&
        await _hasColumn(database, patternSnapshotsTable, 'subject_id') &&
        await _hasColumn(database, generatedInsightsTable, 'subject_id') &&
        await _hasColumn(database, sourceStateTable, 'subject_id') &&
        await _hasColumn(database, glucoseGapsTable, 'subject_id')) {
      return;
    }

    await _rebuildSubjectTables(database);
  }

  Future<void> _createV7(Database database) async {
    // Reserved for historical core database versioning.
  }

  Future<void> _createV8(Database database) async {
    // Reserved for historical core database versioning.
  }

  Future<void> _rebuildSubjectTables(Database database) async {
    await database.transaction((txn) async {
      await _dropSubjectIndexes(txn);
      await _rebuildReadings(txn);
      await _rebuildRawReadings(txn);
      await _rebuildEvents(txn);
      await _rebuildDailyStats(txn);
      await _rebuildPeriodStats(txn);
      await _rebuildSnapshots(txn, agpSnapshotsTable, hasModuleCode: false);
      await _rebuildSnapshots(txn, patternSnapshotsTable, hasModuleCode: true);
      await _rebuildGeneratedInsights(txn);
      await _rebuildSourceState(txn);
      await _rebuildGaps(txn);
      await _createSubjectIndexes(txn);
    });
  }

  Future<void> _dropSubjectIndexes(DatabaseExecutor db) async {
    for (final index in const [
      'idx_readings_ts',
      'idx_raw_readings_bucket',
      'idx_raw_readings_source_ts',
      'idx_events_time',
      'idx_gaps_start',
      'idx_generated_module',
      'idx_generated_slot',
    ]) {
      await db.execute('DROP INDEX IF EXISTS $index');
    }
  }

  Future<void> _createSubjectIndexes(DatabaseExecutor db) async {
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_readings_ts '
      'ON $readingsTable(subject_id, ts_ms DESC)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_raw_readings_bucket '
      'ON $rawReadingsTable(subject_id, bucket_ms)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_raw_readings_source_ts '
      'ON $rawReadingsTable(subject_id, source, ts_ms DESC)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_events_time '
      'ON $eventsTable(subject_id, start_ts_ms DESC)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_generated_slot '
      'ON $generatedInsightsTable(subject_id, module_code, slot_code, generated_at_ms DESC)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_gaps_start '
      'ON $glucoseGapsTable(subject_id, start_ts_ms DESC)',
    );
  }

  Future<void> _rebuildReadings(DatabaseExecutor db) async {
    await db.execute(
      'ALTER TABLE $readingsTable RENAME TO ${readingsTable}_v5',
    );
    await db.execute('''
      CREATE TABLE $readingsTable (
        subject_id TEXT NOT NULL DEFAULT '${GlucoseSubject.selfId}',
        ts_ms INTEGER NOT NULL,
        value REAL NOT NULL,
        rate_per_min REAL,
        source TEXT,
        source_priority INTEGER DEFAULT 100,
        raw_id TEXT,
        updated_at_ms INTEGER,
        PRIMARY KEY(subject_id, ts_ms)
      )
    ''');
    await db.execute('''
      INSERT OR REPLACE INTO $readingsTable
      (subject_id, ts_ms, value, rate_per_min, source, source_priority, raw_id, updated_at_ms)
      SELECT '${GlucoseSubject.selfId}', ts_ms, value, rate_per_min, source,
             COALESCE(source_priority, 100), raw_id, updated_at_ms
      FROM ${readingsTable}_v5
    ''');
    await db.execute('DROP TABLE ${readingsTable}_v5');
  }

  Future<void> _rebuildRawReadings(DatabaseExecutor db) async {
    await db.execute(
      'ALTER TABLE $rawReadingsTable RENAME TO ${rawReadingsTable}_v5',
    );
    await db.execute('''
      CREATE TABLE $rawReadingsTable (
        subject_id TEXT NOT NULL DEFAULT '${GlucoseSubject.selfId}',
        id TEXT NOT NULL,
        source TEXT NOT NULL,
        source_record_id TEXT NOT NULL,
        ts_ms INTEGER NOT NULL,
        bucket_ms INTEGER NOT NULL,
        value REAL NOT NULL,
        rate_per_min REAL,
        received_at_ms INTEGER NOT NULL,
        payload_json TEXT,
        PRIMARY KEY(subject_id, id),
        UNIQUE(subject_id, source, source_record_id),
        UNIQUE(subject_id, source, ts_ms, value)
      )
    ''');
    await db.execute('''
      INSERT OR REPLACE INTO $rawReadingsTable
      (subject_id, id, source, source_record_id, ts_ms, bucket_ms, value, rate_per_min, received_at_ms, payload_json)
      SELECT '${GlucoseSubject.selfId}', id, source, source_record_id, ts_ms, bucket_ms,
             value, rate_per_min, received_at_ms, payload_json
      FROM ${rawReadingsTable}_v5
    ''');
    await db.execute('DROP TABLE ${rawReadingsTable}_v5');
  }

  Future<void> _rebuildEvents(DatabaseExecutor db) async {
    await db.execute('ALTER TABLE $eventsTable RENAME TO ${eventsTable}_v5');
    await db.execute('''
      CREATE TABLE $eventsTable (
        subject_id TEXT NOT NULL DEFAULT '${GlucoseSubject.selfId}',
        id TEXT NOT NULL,
        event_type TEXT NOT NULL,
        start_ts_ms INTEGER NOT NULL,
        end_ts_ms INTEGER,
        value REAL NOT NULL,
        peak_or_nadir REAL,
        rate_per_min REAL,
        low_severity TEXT,
        is_nocturnal INTEGER NOT NULL DEFAULT 0,
        area_out_of_range REAL,
        created_at_ms INTEGER NOT NULL,
        PRIMARY KEY(subject_id, id)
      )
    ''');
    await db.execute('''
      INSERT OR REPLACE INTO $eventsTable
      (subject_id, id, event_type, start_ts_ms, end_ts_ms, value, peak_or_nadir, rate_per_min,
       low_severity, is_nocturnal, area_out_of_range, created_at_ms)
      SELECT '${GlucoseSubject.selfId}', id, event_type, start_ts_ms, end_ts_ms, value,
             peak_or_nadir, rate_per_min, low_severity, is_nocturnal, area_out_of_range, created_at_ms
      FROM ${eventsTable}_v5
    ''');
    await db.execute('DROP TABLE ${eventsTable}_v5');
  }

  Future<void> _rebuildDailyStats(DatabaseExecutor db) async {
    await db.execute(
      'ALTER TABLE $dailyStatsTable RENAME TO ${dailyStatsTable}_v5',
    );
    await db.execute('''
      CREATE TABLE $dailyStatsTable (
        subject_id TEXT NOT NULL DEFAULT '${GlucoseSubject.selfId}',
        day TEXT NOT NULL,
        reading_count INTEGER NOT NULL,
        tir REAL NOT NULL,
        tar REAL NOT NULL,
        tbr REAL NOT NULL,
        mean REAL NOT NULL,
        cv REAL NOT NULL,
        min_value REAL NOT NULL,
        max_value REAL NOT NULL,
        first_reading_value REAL NOT NULL,
        updated_at_ms INTEGER NOT NULL,
        PRIMARY KEY(subject_id, day)
      )
    ''');
    await db.execute('''
      INSERT OR REPLACE INTO $dailyStatsTable
      (subject_id, day, reading_count, tir, tar, tbr, mean, cv, min_value, max_value, first_reading_value, updated_at_ms)
      SELECT '${GlucoseSubject.selfId}', day, reading_count, tir, tar, tbr, mean, cv,
             min_value, max_value, first_reading_value, updated_at_ms
      FROM ${dailyStatsTable}_v5
    ''');
    await db.execute('DROP TABLE ${dailyStatsTable}_v5');
  }

  Future<void> _rebuildPeriodStats(DatabaseExecutor db) async {
    await db.execute(
      'ALTER TABLE $periodStatsTable RENAME TO ${periodStatsTable}_v5',
    );
    await db.execute('''
      CREATE TABLE $periodStatsTable (
        subject_id TEXT NOT NULL DEFAULT '${GlucoseSubject.selfId}',
        period_key TEXT NOT NULL,
        label TEXT NOT NULL,
        reading_count INTEGER NOT NULL,
        tir REAL NOT NULL,
        tar REAL NOT NULL,
        tbr REAL NOT NULL,
        mean REAL NOT NULL,
        cv REAL NOT NULL,
        min_value REAL NOT NULL,
        max_value REAL NOT NULL,
        updated_at_ms INTEGER NOT NULL,
        PRIMARY KEY(subject_id, period_key)
      )
    ''');
    await db.execute('''
      INSERT OR REPLACE INTO $periodStatsTable
      (subject_id, period_key, label, reading_count, tir, tar, tbr, mean, cv, min_value, max_value, updated_at_ms)
      SELECT '${GlucoseSubject.selfId}', period_key, label, reading_count, tir, tar, tbr,
             mean, cv, min_value, max_value, updated_at_ms
      FROM ${periodStatsTable}_v5
    ''');
    await db.execute('DROP TABLE ${periodStatsTable}_v5');
  }

  Future<void> _rebuildSnapshots(
    DatabaseExecutor db,
    String table, {
    required bool hasModuleCode,
  }) async {
    await db.execute('ALTER TABLE $table RENAME TO ${table}_v5');
    await db.execute('''
      CREATE TABLE $table (
        subject_id TEXT NOT NULL DEFAULT '${GlucoseSubject.selfId}',
        snapshot_key TEXT NOT NULL,
        ${hasModuleCode ? 'module_code TEXT NOT NULL,' : ''}
        window_start_ms INTEGER NOT NULL,
        window_end_ms INTEGER NOT NULL,
        payload_json TEXT NOT NULL,
        updated_at_ms INTEGER NOT NULL,
        PRIMARY KEY(subject_id, snapshot_key)
      )
    ''');
    final columns =
        hasModuleCode
            ? 'subject_id, snapshot_key, module_code, window_start_ms, window_end_ms, payload_json, updated_at_ms'
            : 'subject_id, snapshot_key, window_start_ms, window_end_ms, payload_json, updated_at_ms';
    final selectColumns =
        hasModuleCode
            ? "'${GlucoseSubject.selfId}', snapshot_key, module_code, window_start_ms, window_end_ms, payload_json, updated_at_ms"
            : "'${GlucoseSubject.selfId}', snapshot_key, window_start_ms, window_end_ms, payload_json, updated_at_ms";
    await db.execute('''
      INSERT OR REPLACE INTO $table ($columns)
      SELECT $selectColumns FROM ${table}_v5
    ''');
    await db.execute('DROP TABLE ${table}_v5');
  }

  Future<void> _rebuildGeneratedInsights(DatabaseExecutor db) async {
    await db.execute(
      'ALTER TABLE $generatedInsightsTable RENAME TO ${generatedInsightsTable}_v5',
    );
    await db.execute('''
      CREATE TABLE $generatedInsightsTable (
        subject_id TEXT NOT NULL DEFAULT '${GlucoseSubject.selfId}',
        id TEXT NOT NULL,
        module_code TEXT NOT NULL,
        slot_code TEXT NOT NULL,
        insight_type TEXT NOT NULL,
        template_code TEXT NOT NULL,
        template_version INTEGER NOT NULL,
        title TEXT,
        eyebrow TEXT,
        body TEXT NOT NULL,
        footer TEXT,
        facts_json TEXT NOT NULL,
        generated_at_ms INTEGER NOT NULL,
        PRIMARY KEY(subject_id, id)
      )
    ''');
    await db.execute('''
      INSERT OR REPLACE INTO $generatedInsightsTable
      (subject_id, id, module_code, slot_code, insight_type, template_code, template_version,
       title, eyebrow, body, footer, facts_json, generated_at_ms)
      SELECT '${GlucoseSubject.selfId}', id, module_code, slot_code, insight_type, template_code,
             template_version, title, eyebrow, body, footer, facts_json, generated_at_ms
      FROM ${generatedInsightsTable}_v5
    ''');
    await db.execute('DROP TABLE ${generatedInsightsTable}_v5');
  }

  Future<void> _rebuildSourceState(DatabaseExecutor db) async {
    await db.execute(
      'ALTER TABLE $sourceStateTable RENAME TO ${sourceStateTable}_v5',
    );
    await db.execute('''
      CREATE TABLE $sourceStateTable (
        subject_id TEXT NOT NULL DEFAULT '${GlucoseSubject.selfId}',
        source_key TEXT NOT NULL,
        last_success_at_ms INTEGER,
        last_attempt_at_ms INTEGER,
        last_cursor TEXT,
        last_error TEXT,
        updated_at_ms INTEGER NOT NULL,
        PRIMARY KEY(subject_id, source_key)
      )
    ''');
    await db.execute('''
      INSERT OR REPLACE INTO $sourceStateTable
      (subject_id, source_key, last_success_at_ms, last_attempt_at_ms, last_cursor, last_error, updated_at_ms)
      SELECT '${GlucoseSubject.selfId}', source_key, last_success_at_ms, last_attempt_at_ms,
             last_cursor, last_error, updated_at_ms
      FROM ${sourceStateTable}_v5
    ''');
    await db.execute('DROP TABLE ${sourceStateTable}_v5');
  }

  Future<void> _rebuildGaps(DatabaseExecutor db) async {
    await db.execute(
      'ALTER TABLE $glucoseGapsTable RENAME TO ${glucoseGapsTable}_v5',
    );
    await db.execute('''
      CREATE TABLE $glucoseGapsTable (
        subject_id TEXT NOT NULL DEFAULT '${GlucoseSubject.selfId}',
        id TEXT NOT NULL,
        start_ts_ms INTEGER NOT NULL,
        end_ts_ms INTEGER NOT NULL,
        duration_minutes INTEGER NOT NULL,
        source TEXT,
        created_at_ms INTEGER NOT NULL,
        PRIMARY KEY(subject_id, id)
      )
    ''');
    await db.execute('''
      INSERT OR REPLACE INTO $glucoseGapsTable
      (subject_id, id, start_ts_ms, end_ts_ms, duration_minutes, source, created_at_ms)
      SELECT '${GlucoseSubject.selfId}', id, start_ts_ms, end_ts_ms, duration_minutes, source, created_at_ms
      FROM ${glucoseGapsTable}_v5
    ''');
    await db.execute('DROP TABLE ${glucoseGapsTable}_v5');
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

  Future<bool> _hasColumn(
    Database database,
    String table,
    String column,
  ) async {
    final rows = await database.rawQuery('PRAGMA table_info($table)');
    return rows.any((row) => row['name'] == column);
  }

  Future<void> upsertMany(
    List<GlucoseReading> rows, {
    String source = 'unknown',
    String subjectId = GlucoseSubject.selfId,
  }) => readings.upsertMany(rows, source: source, subjectId: subjectId);

  Future<void> upsertCanonicalReadings(
    List<CanonicalGlucoseCandidate> rows, {
    String subjectId = GlucoseSubject.selfId,
  }) => readings.upsertCanonical(rows, subjectId: subjectId);

  Future<void> upsertRawReadings(
    List<RawGlucoseReading> rows, {
    String subjectId = GlucoseSubject.selfId,
  }) => rawReadings.upsertMany(rows, subjectId: subjectId);

  Future<List<RawGlucoseReading>> rawReadingsByBuckets(
    Set<int> bucketMs, {
    String subjectId = GlucoseSubject.selfId,
  }) => rawReadings.byBuckets(bucketMs, subjectId: subjectId);

  Future<GlucoseReading?> latest({String subjectId = GlucoseSubject.selfId}) =>
      readings.latest(subjectId: subjectId);

  Future<List<GlucoseReading>> range(
    DateTime from,
    DateTime to, {
    String subjectId = GlucoseSubject.selfId,
  }) => readings.range(from, to, subjectId: subjectId);

  Future<int> count({String subjectId = GlucoseSubject.selfId}) =>
      readings.count(subjectId: subjectId);

  Future<void> trimOlderThan(
    int retentionDays, {
    String subjectId = GlucoseSubject.selfId,
  }) => readings.trimOlderThan(retentionDays, subjectId: subjectId);

  Future<void> trimRawOlderThan(
    int retentionDays, {
    String subjectId = GlucoseSubject.selfId,
  }) => rawReadings.trimOlderThan(retentionDays, subjectId: subjectId);

  Future<void> clearAll() async {
    final database = await db;
    await database.transaction((txn) async {
      await txn.delete(readingsTable);
      await txn.delete(rawReadingsTable);
      await txn.delete(eventsTable);
      await txn.delete(dailyStatsTable);
      await txn.delete(periodStatsTable);
      await txn.delete(agpSnapshotsTable);
      await txn.delete(patternSnapshotsTable);
      await txn.delete(generatedInsightsTable);
      await txn.delete(glucoseGapsTable);
    });
  }

  Future<void> upsertEvents(
    List<GlucoseEvent> rows, {
    String subjectId = GlucoseSubject.selfId,
  }) => events.upsertEvents(rows, subjectId: subjectId);

  Future<List<GlucoseEvent>> eventsBetween(
    DateTime from,
    DateTime to, {
    String subjectId = GlucoseSubject.selfId,
  }) => events.between(from, to, subjectId: subjectId);

  Future<List<GlucoseEvent>> latestEvents({
    int limit = 200,
    String subjectId = GlucoseSubject.selfId,
  }) => events.latest(limit: limit, subjectId: subjectId);

  Future<void> upsertDailyStats(
    List<DailyGlucoseSummary> summaries, {
    String subjectId = GlucoseSubject.selfId,
  }) => stats.upsertDaily(summaries, subjectId: subjectId);

  Future<List<DailyGlucoseSummary>> latestDailyStats({
    int limit = 90,
    String subjectId = GlucoseSubject.selfId,
  }) => stats.latestDaily(limit: limit, subjectId: subjectId);

  Future<void> upsertPeriodStats(
    List<PeriodGlucoseSummary> summaries, {
    required String windowKey,
    String subjectId = GlucoseSubject.selfId,
  }) => stats.upsertPeriods(
    summaries,
    windowKey: windowKey,
    subjectId: subjectId,
  );

  Future<List<PeriodGlucoseSummary>> periodStatsForWindow(
    String windowKey, {
    String subjectId = GlucoseSubject.selfId,
  }) => stats.periodsForWindow(windowKey, subjectId: subjectId);

  Future<void> putJsonSnapshot({
    required String table,
    required String key,
    required DateTime start,
    required DateTime end,
    required Map<String, Object?> payload,
    String? moduleCode,
    String subjectId = GlucoseSubject.selfId,
  }) => snapshots.putJsonSnapshot(
    table: table,
    key: key,
    start: start,
    end: end,
    payload: payload,
    moduleCode: moduleCode,
    subjectId: subjectId,
  );

  Future<JsonSnapshot?> latestJsonSnapshot(
    String table, {
    String? moduleCode,
    String subjectId = GlucoseSubject.selfId,
  }) => snapshots.latest(table, moduleCode: moduleCode, subjectId: subjectId);

  Future<void> upsertInsightTemplates(List<InsightTemplate> templates) =>
      insights.upsertTemplates(templates);

  Future<List<InsightTemplate>> templatesForModule(AnalysisModuleCode module) =>
      insights.templatesForModule(module);

  Future<void> upsertGeneratedInsights(
    List<NarrativeInsight> rows, {
    String subjectId = GlucoseSubject.selfId,
  }) => insights.upsertGenerated(rows, subjectId: subjectId);

  Future<List<NarrativeInsight>> latestGeneratedInsights({
    AnalysisModuleCode? module,
    int limit = 20,
    String subjectId = GlucoseSubject.selfId,
  }) => insights.latestGenerated(
    module: module,
    limit: limit,
    subjectId: subjectId,
  );

  Future<void> upsertGaps(
    List<GlucoseGap> rows, {
    String subjectId = GlucoseSubject.selfId,
  }) => gaps.upsertGaps(rows, subjectId: subjectId);

  Future<void> recordSourceAttempt(
    String sourceKey, {
    String subjectId = GlucoseSubject.selfId,
  }) => sourceState.recordAttempt(sourceKey, subjectId: subjectId);

  Future<void> recordSourceSuccess(
    String sourceKey, {
    String? cursor,
    String subjectId = GlucoseSubject.selfId,
  }) => sourceState.recordSuccess(
    sourceKey,
    cursor: cursor,
    subjectId: subjectId,
  );

  Future<void> recordSourceError(
    String sourceKey,
    String error, {
    String subjectId = GlucoseSubject.selfId,
  }) => sourceState.recordError(sourceKey, error, subjectId: subjectId);

  Future<SourceSyncState?> getSourceState(
    String sourceKey, {
    String subjectId = GlucoseSubject.selfId,
  }) => sourceState.get(sourceKey, subjectId: subjectId);
}
