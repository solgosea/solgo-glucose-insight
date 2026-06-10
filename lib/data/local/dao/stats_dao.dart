import 'package:sqflite/sqflite.dart';

import '../../../domain/analysis/daily_glucose_summary.dart';
import '../../../domain/analysis/period_glucose_summary.dart';
import '../../../domain/subject/glucose_subject.dart';
import '../glucose_tables.dart';

class StatsDao {
  final Future<Database> Function() _db;

  const StatsDao(this._db);

  Future<void> upsertDaily(
    List<DailyGlucoseSummary> summaries, {
    String subjectId = GlucoseSubject.selfId,
  }) async {
    if (summaries.isEmpty) return;
    final database = await _db();
    final now = DateTime.now().millisecondsSinceEpoch;
    final batch = database.batch();
    for (final s in summaries) {
      batch.insert(GlucoseTables.dailyStats, {
        'day': _dayKey(s.day),
        'subject_id': subjectId,
        'reading_count': s.readingCount,
        'tir': s.tir,
        'tar': s.tar,
        'tbr': s.tbr,
        'mean': s.mean,
        'cv': s.cv,
        'min_value': s.minValue,
        'max_value': s.maxValue,
        'first_reading_value': s.firstReadingValue,
        'updated_at_ms': now,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<void> upsertPeriods(
    List<PeriodGlucoseSummary> summaries, {
    required String windowKey,
    String subjectId = GlucoseSubject.selfId,
  }) async {
    if (summaries.isEmpty) return;
    final database = await _db();
    final now = DateTime.now().millisecondsSinceEpoch;
    final batch = database.batch();
    for (final s in summaries) {
      batch.insert(GlucoseTables.periodStats, {
        'period_key': '${windowKey}_${s.periodKey}',
        'subject_id': subjectId,
        'label': s.label,
        'reading_count': s.readingCount,
        'tir': s.tir,
        'tar': s.tar,
        'tbr': s.tbr,
        'mean': s.mean,
        'cv': s.cv,
        'min_value': s.minValue,
        'max_value': s.maxValue,
        'updated_at_ms': now,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<List<DailyGlucoseSummary>> latestDaily({
    int limit = 90,
    String subjectId = GlucoseSubject.selfId,
  }) async {
    final database = await _db();
    final rows = await database.query(
      GlucoseTables.dailyStats,
      where: 'subject_id = ?',
      whereArgs: [subjectId],
      orderBy: 'day DESC',
      limit: limit,
    );
    final result = rows.map(_toDaily).toList();
    result.sort((a, b) => a.day.compareTo(b.day));
    return result;
  }

  Future<List<PeriodGlucoseSummary>> periodsForWindow(
    String windowKey, {
    String subjectId = GlucoseSubject.selfId,
  }) async {
    final database = await _db();
    final rows = await database.query(
      GlucoseTables.periodStats,
      where: 'subject_id = ? AND period_key LIKE ?',
      whereArgs: [subjectId, '$windowKey%'],
      orderBy: 'period_key ASC',
    );
    return rows.map((row) => _toPeriod(row, windowKey)).toList();
  }

  DailyGlucoseSummary _toDaily(Map<String, Object?> row) => DailyGlucoseSummary(
    day: DateTime.parse(row['day'] as String),
    readingCount: row['reading_count'] as int,
    tir: (row['tir'] as num).toDouble(),
    tar: (row['tar'] as num).toDouble(),
    tbr: (row['tbr'] as num).toDouble(),
    mean: (row['mean'] as num).toDouble(),
    cv: (row['cv'] as num).toDouble(),
    minValue: (row['min_value'] as num).toDouble(),
    maxValue: (row['max_value'] as num).toDouble(),
    firstReadingValue: (row['first_reading_value'] as num).toDouble(),
  );

  PeriodGlucoseSummary _toPeriod(Map<String, Object?> row, String windowKey) {
    final rawKey = row['period_key'] as String;
    final prefix = '${windowKey}_';
    return PeriodGlucoseSummary(
      periodKey:
          rawKey.startsWith(prefix) ? rawKey.substring(prefix.length) : rawKey,
      label: row['label'] as String,
      readingCount: row['reading_count'] as int,
      tir: (row['tir'] as num).toDouble(),
      tar: (row['tar'] as num).toDouble(),
      tbr: (row['tbr'] as num).toDouble(),
      mean: (row['mean'] as num).toDouble(),
      cv: (row['cv'] as num).toDouble(),
      minValue: (row['min_value'] as num).toDouble(),
      maxValue: (row['max_value'] as num).toDouble(),
    );
  }

  String _dayKey(DateTime day) =>
      '${day.year.toString().padLeft(4, '0')}-'
      '${day.month.toString().padLeft(2, '0')}-'
      '${day.day.toString().padLeft(2, '0')}';
}
