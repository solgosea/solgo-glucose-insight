import 'package:sqflite/sqflite.dart';

import '../../../domain/entities/glucose_event.dart';
import '../../../domain/subject/glucose_subject.dart';
import '../glucose_tables.dart';

class EventsDao {
  final Future<Database> Function() _db;

  const EventsDao(this._db);

  Future<void> upsertEvents(
    List<GlucoseEvent> events, {
    String subjectId = GlucoseSubject.selfId,
  }) async {
    if (events.isEmpty) return;
    final database = await _db();
    final now = DateTime.now().millisecondsSinceEpoch;
    final batch = database.batch();
    for (final e in events) {
      batch.insert(GlucoseTables.events, {
        'id': eventId(e),
        'subject_id': subjectId,
        'event_type': e.type.name,
        'start_ts_ms': e.time.millisecondsSinceEpoch,
        'end_ts_ms': e.endTime?.millisecondsSinceEpoch,
        'value': e.value,
        'peak_or_nadir': e.peakOrNadir,
        'rate_per_min': e.ratePerMin,
        'low_severity': e.lowSeverity?.name,
        'is_nocturnal': e.isNocturnal ? 1 : 0,
        'area_out_of_range': e.areaOutOfRange,
        'created_at_ms': now,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<List<GlucoseEvent>> between(
    DateTime from,
    DateTime to, {
    String subjectId = GlucoseSubject.selfId,
  }) async {
    final database = await _db();
    final rows = await database.query(
      GlucoseTables.events,
      where: 'subject_id = ? AND start_ts_ms >= ? AND start_ts_ms < ?',
      whereArgs: [
        subjectId,
        from.millisecondsSinceEpoch,
        to.millisecondsSinceEpoch,
      ],
      orderBy: 'start_ts_ms ASC',
    );
    return rows.map(_toEvent).toList();
  }

  Future<List<GlucoseEvent>> latest({
    int limit = 200,
    String subjectId = GlucoseSubject.selfId,
  }) async {
    final database = await _db();
    final rows = await database.query(
      GlucoseTables.events,
      where: 'subject_id = ?',
      whereArgs: [subjectId],
      orderBy: 'start_ts_ms DESC',
      limit: limit,
    );
    final result = rows.map(_toEvent).toList();
    result.sort((a, b) => a.time.compareTo(b.time));
    return result;
  }

  static String eventId(GlucoseEvent event) =>
      '${event.type.name}_${event.time.millisecondsSinceEpoch}';

  GlucoseEvent _toEvent(Map<String, Object?> row) => GlucoseEvent(
    type: GlucoseEventType.values.firstWhere(
      (t) => t.name == row['event_type'],
      orElse: () => GlucoseEventType.highEpisode,
    ),
    time: DateTime.fromMillisecondsSinceEpoch(row['start_ts_ms'] as int),
    value: (row['value'] as num).toDouble(),
    endTime:
        row['end_ts_ms'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(row['end_ts_ms'] as int),
    peakOrNadir: (row['peak_or_nadir'] as num?)?.toDouble(),
    ratePerMin: (row['rate_per_min'] as num?)?.toDouble(),
    lowSeverity:
        row['low_severity'] == null
            ? null
            : LowSeverity.values.firstWhere(
              (s) => s.name == row['low_severity'],
              orElse: () => LowSeverity.mild,
            ),
    isNocturnal: row['is_nocturnal'] == 1,
    areaOutOfRange: (row['area_out_of_range'] as num?)?.toDouble(),
  );
}
