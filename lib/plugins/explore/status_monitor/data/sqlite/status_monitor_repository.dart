import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../../domain/status_component_kind.dart';
import '../../domain/history/status_component_history_sample.dart';
import '../../domain/history/status_history_query.dart';
import '../../domain/history/status_history_scope.dart';
import '../../domain/history/status_history_window.dart';
import '../../domain/history/status_history_sample_source.dart';
import '../../domain/status_level.dart';
import '../../domain/status_report.dart';
import '../../domain/status_timeline_point.dart';
import '../../domain/widget/status_monitor_widget_display_mode.dart';
import '../../domain/widget/status_widget_settings.dart';
import 'status_monitor_schema.dart';
import 'status_monitor_tables.dart';

class StatusMonitorRepository {
  final Future<Database> Function() databaseProvider;
  bool _schemaReady = false;

  StatusMonitorRepository({
    required this.databaseProvider,
  });

  Future<Database> get _database async {
    final database = await databaseProvider();
    if (!_schemaReady) {
      await const StatusMonitorSchema().install(database);
      _schemaReady = true;
    }
    return database;
  }

  Future<void> saveReport(StatusReport report) async {
    final database = await _database;
    await database.insert(
      StatusMonitorTables.reports,
      {
        'subject_id': report.subjectId,
        'source_target_id': report.sourceTargetId,
        'source_kind': report.sourceKind,
        'source_label': report.sourceLabel,
        'generated_at_ms': report.generatedAt.millisecondsSinceEpoch,
        'payload_json': jsonEncode(report.toJson()),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertHistorySample({
    required String subjectId,
    required StatusComponentHistorySample sample,
  }) async {
    final database = await _database;
    await database.insert(
      StatusMonitorTables.history,
      {
        'subject_id': subjectId,
        'source_target_id': sample.source.targetId,
        'source_kind': sample.source.kind,
        'source_label': sample.source.label,
        'component': sample.component.name,
        'level': sample.level.name,
        'score': sample.score,
        'confidence': sample.confidence,
        'summary': sample.summary,
        'at_ms': sample.at.millisecondsSinceEpoch,
      },
    );
  }

  Future<List<StatusTimelinePoint>> latestHistory({
    required String subjectId,
    String? sourceTargetId,
    DateTime? from,
    DateTime? to,
    int limit = 21,
  }) async {
    if (from != null && to != null) {
      return queryHistory(
        StatusHistoryQuery(
          scope: StatusHistoryScope(
            subjectId: subjectId,
            sourceTargetId: sourceTargetId,
          ),
          window: StatusHistoryWindow(from: from, to: to),
        ),
      );
    }
    final database = await _database;
    final where = StringBuffer('subject_id = ?');
    final args = <Object?>[subjectId];
    final target = sourceTargetId?.trim();
    if (target == null || target.isEmpty) {
      where.write(' AND source_target_id IS NULL');
    } else {
      where.write(' AND source_target_id = ?');
      args.add(target);
    }
    final rows = await database.query(
      StatusMonitorTables.history,
      where: where.toString(),
      whereArgs: args,
      orderBy: 'at_ms DESC',
      limit: limit,
    );
    return rows
        .map(_historySampleFromRow)
        .map(_timelineFromSample)
        .toList(growable: false)
        .reversed
        .toList();
  }

  Future<List<StatusTimelinePoint>> queryHistory(
    StatusHistoryQuery query,
  ) async {
    final samples = await queryHistorySamples(query);
    return samples.map(_timelineFromSample).toList(growable: false);
  }

  Future<List<StatusComponentHistorySample>> queryHistorySamples(
    StatusHistoryQuery query,
  ) async {
    return queryComponentHistorySamples(query);
  }

  Future<List<StatusComponentHistorySample>> queryComponentHistorySamples(
    StatusHistoryQuery query, {
    StatusComponentKind? component,
  }) async {
    final database = await _database;
    final where = StringBuffer('subject_id = ? AND at_ms >= ? AND at_ms <= ?');
    final args = <Object?>[
      query.scope.subjectId,
      query.window.from.millisecondsSinceEpoch,
      query.window.to.millisecondsSinceEpoch,
    ];
    final target = query.scope.sourceTargetId;
    if (target == null || target.isEmpty) {
      where.write(' AND source_target_id IS NULL');
    } else {
      where.write(' AND source_target_id = ?');
      args.add(target);
    }
    if (component != null) {
      where.write(' AND component = ?');
      args.add(component.name);
    }
    final rows = await database.query(
      StatusMonitorTables.history,
      where: where.toString(),
      whereArgs: args,
      orderBy: 'at_ms ASC',
    );
    return rows.map(_historySampleFromRow).toList(growable: false);
  }

  Future<bool> persistentNotificationEnabled(String subjectId) async {
    final settings = await widgetSettings(subjectId);
    return settings.persistentNotificationEnabled;
  }

  Future<bool> lowBatteryMode(String subjectId) async {
    final settings = await widgetSettings(subjectId);
    return settings.lowBatteryMode;
  }

  Future<StatusWidgetSettings> widgetSettings(String subjectId) async {
    final database = await _database;
    final rows = await database.query(
      StatusMonitorTables.settings,
      where: 'subject_id = ?',
      whereArgs: [subjectId],
      limit: 1,
    );
    if (rows.isEmpty) return StatusWidgetSettings.defaults(subjectId);
    return StatusWidgetSettings(
      subjectId: subjectId,
      persistentNotificationEnabled:
          rows.first['persistent_notification_enabled'] == 1,
      lockScreenEnabled: rows.first['lock_screen_enabled'] == 1,
      lowBatteryMode: rows.first['low_battery_mode'] == 1,
      notificationDisplayMode: StatusMonitorWidgetDisplayMode.fromCode(
        rows.first['notification_display_mode']?.toString(),
      ),
      lockScreenDisplayMode: StatusMonitorWidgetDisplayMode.fromCode(
        rows.first['lock_screen_display_mode']?.toString(),
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        rows.first['updated_at_ms'] as int,
      ),
    );
  }

  Future<void> setPersistentNotificationEnabled(
    String subjectId,
    bool enabled,
  ) async {
    final settings = await widgetSettings(subjectId);
    await _saveSettings(
      settings.copyWith(
        persistentNotificationEnabled: enabled,
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<void> setLockScreenEnabled(String subjectId, bool enabled) async {
    final settings = await widgetSettings(subjectId);
    await _saveSettings(
      settings.copyWith(
        lockScreenEnabled: enabled,
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<void> setLowBatteryMode(
    String subjectId,
    bool enabled,
  ) async {
    final settings = await widgetSettings(subjectId);
    await _saveSettings(
      settings.copyWith(
        lowBatteryMode: enabled,
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<void> setNotificationDisplayMode(
    String subjectId,
    StatusMonitorWidgetDisplayMode mode,
  ) async {
    final settings = await widgetSettings(subjectId);
    await _saveSettings(
      settings.copyWith(
        notificationDisplayMode: mode,
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<void> setLockScreenDisplayMode(
    String subjectId,
    StatusMonitorWidgetDisplayMode mode,
  ) async {
    final settings = await widgetSettings(subjectId);
    await _saveSettings(
      settings.copyWith(
        lockScreenDisplayMode: mode,
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<void> _saveSettings(StatusWidgetSettings settings) async {
    final database = await _database;
    await database.insert(
      StatusMonitorTables.settings,
      {
        'subject_id': settings.subjectId,
        'persistent_notification_enabled':
            settings.persistentNotificationEnabled ? 1 : 0,
        'lock_screen_enabled': settings.lockScreenEnabled ? 1 : 0,
        'low_battery_mode': settings.lowBatteryMode ? 1 : 0,
        'notification_display_mode': settings.notificationDisplayMode.code,
        'lock_screen_display_mode': settings.lockScreenDisplayMode.code,
        'updated_at_ms': settings.updatedAt.millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  StatusComponentHistorySample _historySampleFromRow(
    Map<String, Object?> row,
  ) {
    final score = row['score'];
    final confidence = row['confidence'];
    return StatusComponentHistorySample(
      at: DateTime.fromMillisecondsSinceEpoch(row['at_ms'] as int),
      component: _component(row['component'] as String?),
      level: _level(row['level'] as String?),
      score: score is int ? score : null,
      confidence: confidence is num ? confidence.toDouble() : null,
      summary: row['summary']?.toString() ?? '',
      source: StatusHistorySampleSource(
        targetId: row['source_target_id']?.toString(),
        kind: row['source_kind']?.toString() ?? 'unknown',
        label: row['source_label']?.toString() ?? 'Unknown source',
      ),
    );
  }

  StatusTimelinePoint _timelineFromSample(StatusComponentHistorySample sample) {
    return StatusTimelinePoint(
      at: sample.at,
      component: sample.component,
      level: sample.level,
      summary: sample.summary,
    );
  }

  StatusComponentKind _component(String? value) {
    return StatusComponentKind.values.firstWhere(
      (kind) => kind.name == value,
      orElse: () => StatusComponentKind.nightscout,
    );
  }

  StatusLevel _level(String? value) {
    return StatusLevel.values.firstWhere(
      (level) => level.name == value,
      orElse: () => StatusLevel.unknown,
    );
  }
}
