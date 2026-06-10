import 'package:sqflite/sqflite.dart';

import '../../../domain/entities/source_sync_state.dart';
import '../../../domain/subject/glucose_subject.dart';
import '../glucose_tables.dart';

class SourceStateDao {
  final Future<Database> Function() _db;

  const SourceStateDao(this._db);

  Future<void> recordAttempt(
    String sourceKey, {
    String subjectId = GlucoseSubject.selfId,
  }) async {
    await _upsert(
      sourceKey,
      subjectId: subjectId,
      lastAttemptAt: DateTime.now(),
    );
  }

  Future<void> recordSuccess(
    String sourceKey, {
    String? cursor,
    String subjectId = GlucoseSubject.selfId,
  }) async {
    final now = DateTime.now();
    await _upsert(
      sourceKey,
      subjectId: subjectId,
      lastAttemptAt: now,
      lastSuccessAt: now,
      lastCursor: cursor,
    );
  }

  Future<void> recordError(
    String sourceKey,
    String error, {
    String subjectId = GlucoseSubject.selfId,
  }) async {
    await _upsert(
      sourceKey,
      subjectId: subjectId,
      lastAttemptAt: DateTime.now(),
      lastError: error,
    );
  }

  Future<SourceSyncState?> get(
    String sourceKey, {
    String subjectId = GlucoseSubject.selfId,
  }) async {
    final database = await _db();
    final rows = await database.query(
      GlucoseTables.sourceState,
      where: 'subject_id = ? AND source_key = ?',
      whereArgs: [subjectId, sourceKey],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    final row = rows.first;
    return SourceSyncState(
      sourceKey: row['source_key'] as String,
      lastSuccessAt: _date(row['last_success_at_ms']),
      lastAttemptAt: _date(row['last_attempt_at_ms']),
      lastCursor: row['last_cursor'] as String?,
      lastError: row['last_error'] as String?,
      updatedAt: _date(row['updated_at_ms']) ?? DateTime.now(),
    );
  }

  Future<void> _upsert(
    String sourceKey, {
    required String subjectId,
    DateTime? lastSuccessAt,
    DateTime? lastAttemptAt,
    String? lastCursor,
    String? lastError,
  }) async {
    final database = await _db();
    final existing = await get(sourceKey, subjectId: subjectId);
    await database.insert(GlucoseTables.sourceState, {
      'source_key': sourceKey,
      'subject_id': subjectId,
      'last_success_at_ms':
          (lastSuccessAt ?? existing?.lastSuccessAt)?.millisecondsSinceEpoch,
      'last_attempt_at_ms':
          (lastAttemptAt ?? existing?.lastAttemptAt)?.millisecondsSinceEpoch,
      'last_cursor': lastCursor ?? existing?.lastCursor,
      'last_error': lastError,
      'updated_at_ms': DateTime.now().millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  DateTime? _date(Object? value) =>
      value == null ? null : DateTime.fromMillisecondsSinceEpoch(value as int);
}
