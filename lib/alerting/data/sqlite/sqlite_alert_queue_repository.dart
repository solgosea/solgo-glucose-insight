import 'package:sqflite/sqflite.dart';

import '../../alerting_tables.dart';
import '../../domain/queue/alert_queue_message.dart';
import '../../domain/queue/alert_queue_message_state.dart';
import '../../domain/repository/alert_queue_repository.dart';
import 'queue/alert_queue_row_mapper.dart';

class SqliteAlertQueueRepository implements AlertQueueRepository {
  final Future<Database> Function() databaseProvider;
  final AlertQueueRowMapper mapper;

  const SqliteAlertQueueRepository({
    required this.databaseProvider,
    this.mapper = const AlertQueueRowMapper(),
  });

  @override
  Future<void> enqueue(AlertQueueMessage message) async {
    final db = await databaseProvider();
    await db.insert(
      AlertingTables.queueMessages,
      mapper.toRow(message),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  @override
  Future<AlertQueueMessage?> findByDedupeKey(String dedupeKey) async {
    final db = await databaseProvider();
    final rows = await db.query(
      AlertingTables.queueMessages,
      where: 'dedupe_key = ?',
      whereArgs: [dedupeKey],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return mapper.fromRow(rows.first);
  }

  @override
  Future<void> replaceByDedupeKey(AlertQueueMessage message) async {
    final db = await databaseProvider();
    await db.update(
      AlertingTables.queueMessages,
      mapper.toRow(message),
      where: 'dedupe_key = ?',
      whereArgs: [message.dedupeKey],
    );
  }

  @override
  Future<List<AlertQueueMessage>> lockNextBatch({
    required int limit,
    required DateTime now,
  }) async {
    final db = await databaseProvider();
    return db.transaction((txn) async {
      final rows = await txn.query(
        AlertingTables.queueMessages,
        where: 'state = ? AND available_at_ms <= ?',
        whereArgs: [
          AlertQueueMessageState.pending.code,
          now.millisecondsSinceEpoch,
        ],
        orderBy: '''
          CASE priority
            WHEN 'critical' THEN 3
            WHEN 'high' THEN 2
            WHEN 'normal' THEN 1
            ELSE 0
          END DESC,
          created_at_ms ASC
        ''',
        limit: limit,
      );
      final messages = rows.map(mapper.fromRow).toList(growable: false);
      if (messages.isEmpty) return messages;
      final ids = messages.map((message) => message.id).toList(growable: false);
      final placeholders = List.filled(ids.length, '?').join(',');
      await txn.update(
        AlertingTables.queueMessages,
        {
          'state': AlertQueueMessageState.processing.code,
          'locked_at_ms': now.millisecondsSinceEpoch,
          'updated_at_ms': now.millisecondsSinceEpoch,
        },
        where: 'id IN ($placeholders)',
        whereArgs: ids,
      );
      return [
        for (final message in messages)
          message.copyWith(
            state: AlertQueueMessageState.processing,
            lockedAt: now,
            updatedAt: now,
          ),
      ];
    });
  }

  @override
  Future<void> markProcessed(String id, DateTime processedAt) async {
    final db = await databaseProvider();
    await db.update(
      AlertingTables.queueMessages,
      {
        'state': AlertQueueMessageState.processed.code,
        'processed_at_ms': processedAt.millisecondsSinceEpoch,
        'updated_at_ms': processedAt.millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> markFailed({
    required String id,
    required String reason,
    required DateTime failedAt,
  }) async {
    final db = await databaseProvider();
    await db.update(
      AlertingTables.queueMessages,
      {
        'state': AlertQueueMessageState.failed.code,
        'failed_reason': reason,
        'updated_at_ms': failedAt.millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> releaseForRetry({
    required String id,
    required String reason,
    required int attemptCount,
    required DateTime availableAt,
    required DateTime updatedAt,
  }) async {
    final db = await databaseProvider();
    await db.update(
      AlertingTables.queueMessages,
      {
        'state': AlertQueueMessageState.pending.code,
        'attempt_count': attemptCount,
        'available_at_ms': availableAt.millisecondsSinceEpoch,
        'failed_reason': reason,
        'locked_at_ms': null,
        'updated_at_ms': updatedAt.millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<int> pendingCount() async {
    final db = await databaseProvider();
    final result = await db.rawQuery(
      'SELECT COUNT(*) AS count FROM ${AlertingTables.queueMessages} '
      'WHERE state = ?',
      [AlertQueueMessageState.pending.code],
    );
    return (result.first['count'] as num?)?.round() ?? 0;
  }
}
