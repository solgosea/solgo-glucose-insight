import 'package:sqflite/sqflite.dart';

import '../../../domain/glucose_etl/raw_glucose_reading.dart';
import '../../../domain/subject/glucose_subject.dart';
import '../glucose_tables.dart';

class RawReadingsDao {
  final Future<Database> Function() _db;

  const RawReadingsDao(this._db);

  Future<void> upsertMany(
    List<RawGlucoseReading> readings, {
    String subjectId = GlucoseSubject.selfId,
  }) async {
    if (readings.isEmpty) return;
    final database = await _db();
    final batch = database.batch();
    for (final reading in readings) {
      batch.insert(
        GlucoseTables.rawReadings,
        _toRow(reading, subjectId: subjectId),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<RawGlucoseReading>> byBuckets(
    Set<int> bucketMs, {
    String subjectId = GlucoseSubject.selfId,
  }) async {
    if (bucketMs.isEmpty) return const [];
    final database = await _db();
    final placeholders = List.filled(bucketMs.length, '?').join(',');
    final rows = await database.query(
      GlucoseTables.rawReadings,
      where: 'subject_id = ? AND bucket_ms IN ($placeholders)',
      whereArgs: [subjectId, ...bucketMs],
      orderBy: 'bucket_ms ASC, ts_ms ASC, source ASC, id ASC',
    );
    return rows.map(_fromRow).toList();
  }

  Future<int> count({String subjectId = GlucoseSubject.selfId}) async {
    final database = await _db();
    final rows = await database.rawQuery(
      'SELECT COUNT(*) AS c FROM ${GlucoseTables.rawReadings} WHERE subject_id = ?',
      [subjectId],
    );
    return (rows.first['c'] as int?) ?? 0;
  }

  Future<void> trimOlderThan(
    int retentionDays, {
    String subjectId = GlucoseSubject.selfId,
  }) async {
    final database = await _db();
    final cutoff =
        DateTime.now()
            .subtract(Duration(days: retentionDays))
            .millisecondsSinceEpoch;
    await database.delete(
      GlucoseTables.rawReadings,
      where: 'subject_id = ? AND ts_ms < ?',
      whereArgs: [subjectId, cutoff],
    );
  }

  Map<String, Object?> _toRow(
    RawGlucoseReading reading, {
    required String subjectId,
  }) {
    return {
      'id': reading.id,
      'subject_id': subjectId,
      'source': reading.source,
      'source_record_id': reading.sourceRecordId,
      'ts_ms': reading.timestamp.millisecondsSinceEpoch,
      'bucket_ms': reading.bucketMs,
      'value': reading.value,
      'rate_per_min': reading.ratePerMin,
      'received_at_ms': reading.receivedAt.millisecondsSinceEpoch,
      'payload_json': reading.payloadJson,
    };
  }

  RawGlucoseReading _fromRow(Map<String, Object?> row) {
    return RawGlucoseReading(
      id: row['id'] as String,
      source: row['source'] as String,
      sourceRecordId: row['source_record_id'] as String,
      timestamp: DateTime.fromMillisecondsSinceEpoch(row['ts_ms'] as int),
      bucketMs: row['bucket_ms'] as int,
      value: (row['value'] as num).toDouble(),
      ratePerMin: (row['rate_per_min'] as num?)?.toDouble(),
      receivedAt: DateTime.fromMillisecondsSinceEpoch(
        row['received_at_ms'] as int,
      ),
      payloadJson: row['payload_json'] as String?,
    );
  }
}
