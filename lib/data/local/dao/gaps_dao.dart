import 'package:sqflite/sqflite.dart';

import '../../../domain/entities/glucose_gap.dart';
import '../../../domain/subject/glucose_subject.dart';
import '../glucose_tables.dart';

class GapsDao {
  final Future<Database> Function() _db;

  const GapsDao(this._db);

  Future<void> upsertGaps(
    List<GlucoseGap> gaps, {
    String subjectId = GlucoseSubject.selfId,
  }) async {
    if (gaps.isEmpty) return;
    final database = await _db();
    final now = DateTime.now().millisecondsSinceEpoch;
    final batch = database.batch();
    for (final gap in gaps) {
      batch.insert(GlucoseTables.glucoseGaps, {
        'id': gap.id,
        'subject_id': subjectId,
        'start_ts_ms': gap.start.millisecondsSinceEpoch,
        'end_ts_ms': gap.end.millisecondsSinceEpoch,
        'duration_minutes': gap.durationMinutes,
        'source': gap.source,
        'created_at_ms': now,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }
}
