import 'package:sqflite/sqflite.dart';

import '../../../domain/entities/glucose_reading.dart';
import '../../../domain/glucose_etl/canonical_glucose_candidate.dart';
import '../../../domain/subject/glucose_subject.dart';
import '../glucose_tables.dart';

class ReadingsDao {
  final Future<Database> Function() _db;

  const ReadingsDao(this._db);

  Future<void> upsertMany(
    List<GlucoseReading> readings, {
    String source = 'unknown',
    String subjectId = GlucoseSubject.selfId,
  }) async {
    if (readings.isEmpty) return;
    final database = await _db();
    final batch = database.batch();
    for (final r in readings) {
      batch.insert(
        GlucoseTables.readings,
        {
          'ts_ms': r.timestamp.millisecondsSinceEpoch,
          'subject_id': subjectId,
          'value': r.value,
          'rate_per_min': r.ratePerMin,
          'source': source,
          'source_priority': 100,
          'raw_id': null,
          'updated_at_ms': DateTime.now().millisecondsSinceEpoch,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<void> upsertCanonical(
    List<CanonicalGlucoseCandidate> readings, {
    String subjectId = GlucoseSubject.selfId,
  }) async {
    if (readings.isEmpty) return;
    final database = await _db();
    final batch = database.batch();
    for (final reading in readings) {
      const bucketHalfWidthMs = 15000;
      batch.delete(
        GlucoseTables.readings,
        where: 'subject_id = ? AND ts_ms >= ? AND ts_ms < ?',
        whereArgs: [
          subjectId,
          reading.bucketMs - bucketHalfWidthMs,
          reading.bucketMs + bucketHalfWidthMs,
        ],
      );
      batch.insert(
        GlucoseTables.readings,
        {
          'ts_ms': reading.timestamp.millisecondsSinceEpoch,
          'subject_id': subjectId,
          'value': reading.value,
          'rate_per_min': reading.ratePerMin,
          'source': reading.source,
          'source_priority': reading.sourcePriority,
          'raw_id': reading.rawId,
          'updated_at_ms': reading.updatedAt.millisecondsSinceEpoch,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<GlucoseReading?> latest({
    String subjectId = GlucoseSubject.selfId,
  }) async {
    final database = await _db();
    final rows = await database.query(
      GlucoseTables.readings,
      where: 'subject_id = ?',
      whereArgs: [subjectId],
      orderBy: 'ts_ms DESC',
      limit: 1,
    );
    return rows.isEmpty ? null : _toReading(rows.first);
  }

  Future<GlucoseReading?> earliest({
    String subjectId = GlucoseSubject.selfId,
  }) async {
    final database = await _db();
    final rows = await database.query(
      GlucoseTables.readings,
      where: 'subject_id = ?',
      whereArgs: [subjectId],
      orderBy: 'ts_ms ASC',
      limit: 1,
    );
    return rows.isEmpty ? null : _toReading(rows.first);
  }

  Future<GlucoseReading?> latestAnySubject() async {
    final database = await _db();
    final rows = await database.query(
      GlucoseTables.readings,
      orderBy: 'ts_ms DESC',
      limit: 1,
    );
    return rows.isEmpty ? null : _toReading(rows.first);
  }

  Future<List<GlucoseReading>> range(
    DateTime from,
    DateTime to, {
    String subjectId = GlucoseSubject.selfId,
  }) async {
    final database = await _db();
    final rows = await database.query(
      GlucoseTables.readings,
      where: 'subject_id = ? AND ts_ms >= ? AND ts_ms < ?',
      whereArgs: [
        subjectId,
        from.millisecondsSinceEpoch,
        to.millisecondsSinceEpoch,
      ],
      orderBy: 'ts_ms ASC',
    );
    return rows.map(_toReading).toList();
  }

  Future<List<GlucoseReading>> rangeAnySubject(
    DateTime from,
    DateTime to,
  ) async {
    final database = await _db();
    final rows = await database.query(
      GlucoseTables.readings,
      where: 'ts_ms >= ? AND ts_ms < ?',
      whereArgs: [
        from.millisecondsSinceEpoch,
        to.millisecondsSinceEpoch,
      ],
      orderBy: 'ts_ms ASC',
    );
    return rows.map(_toReading).toList();
  }

  Future<int> count({
    String subjectId = GlucoseSubject.selfId,
  }) async {
    final database = await _db();
    final r = await database.rawQuery(
      'SELECT COUNT(*) AS c FROM ${GlucoseTables.readings} WHERE subject_id = ?',
      [subjectId],
    );
    return (r.first['c'] as int?) ?? 0;
  }

  Future<void> trimOlderThan(
    int retentionDays, {
    String subjectId = GlucoseSubject.selfId,
  }) async {
    final database = await _db();
    final cutoff = DateTime.now()
        .subtract(Duration(days: retentionDays))
        .millisecondsSinceEpoch;
    await database.delete(
      GlucoseTables.readings,
      where: 'subject_id = ? AND ts_ms < ?',
      whereArgs: [subjectId, cutoff],
    );
  }

  GlucoseReading _toReading(Map<String, Object?> row) => GlucoseReading(
        timestamp: DateTime.fromMillisecondsSinceEpoch(row['ts_ms'] as int),
        value: (row['value'] as num).toDouble(),
        ratePerMin: (row['rate_per_min'] as num?)?.toDouble(),
      );
}
