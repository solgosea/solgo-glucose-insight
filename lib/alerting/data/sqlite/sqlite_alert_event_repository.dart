import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../../alerting_tables.dart';
import '../../domain/event/alert_category.dart';
import '../../domain/event/alert_event.dart';
import '../../domain/event/alert_event_source.dart';
import '../../domain/event/alert_event_state.dart';
import '../../domain/event/alert_level.dart';
import '../../domain/repository/alert_event_repository.dart';

class SqliteAlertEventRepository implements AlertEventRepository {
  final Future<Database> Function() databaseProvider;

  const SqliteAlertEventRepository({required this.databaseProvider});

  @override
  Future<void> upsert(AlertEvent event) async {
    final database = await databaseProvider();
    await database.insert(
      AlertingTables.events,
      _toRow(event),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<AlertEvent?> byId(String id) async {
    final database = await databaseProvider();
    final rows = await database.query(
      AlertingTables.events,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return _fromRow(rows.first);
  }

  @override
  Future<List<AlertEvent>> latest({int limit = 50}) async {
    final database = await databaseProvider();
    final rows = await database.query(
      AlertingTables.events,
      orderBy: 'occurred_at DESC',
      limit: limit,
    );
    return rows.map(_fromRow).toList(growable: false);
  }

  @override
  Future<void> updateState(String id, AlertEventState state) async {
    final database = await databaseProvider();
    await database.update(
      AlertingTables.events,
      {'state': state.name, 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Map<String, Object?> _toRow(AlertEvent event) => {
    'id': event.id,
    'source': event.source.code,
    'source_event_id': event.sourceEventId,
    'category': event.category.code,
    'level': event.level.name,
    'state': event.state.name,
    'title': event.title,
    'body': event.body,
    'payload_json': jsonEncode(event.payload),
    'occurred_at': event.occurredAt.toIso8601String(),
    'received_at': event.receivedAt.toIso8601String(),
    'updated_at': event.updatedAt.toIso8601String(),
  };

  AlertEvent _fromRow(Map<String, Object?> row) {
    return AlertEvent(
      id: row['id'] as String,
      source: AlertEventSource.fromCode(row['source'] as String),
      sourceEventId: row['source_event_id'] as String?,
      category: AlertCategory.fromCode(row['category'] as String),
      level: AlertLevel.values.firstWhere(
        (value) => value.name == row['level'],
        orElse: () => AlertLevel.warning,
      ),
      state: AlertEventState.values.firstWhere(
        (value) => value.name == row['state'],
        orElse: () => AlertEventState.received,
      ),
      title: row['title'] as String,
      body: row['body'] as String,
      payload: _decodeMap(row['payload_json'] as String?),
      occurredAt: DateTime.parse(row['occurred_at'] as String),
      receivedAt: DateTime.parse(row['received_at'] as String),
      updatedAt: DateTime.parse(row['updated_at'] as String),
    );
  }

  Map<String, Object?> _decodeMap(String? json) {
    if (json == null || json.isEmpty) return const {};
    final decoded = jsonDecode(json);
    if (decoded is Map) return decoded.cast<String, Object?>();
    return const {};
  }
}
