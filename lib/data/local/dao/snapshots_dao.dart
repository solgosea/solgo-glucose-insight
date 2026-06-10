import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../../../domain/analysis/json_snapshot.dart';
import '../../../domain/subject/glucose_subject.dart';

class SnapshotsDao {
  final Future<Database> Function() _db;

  const SnapshotsDao(this._db);

  Future<void> putJsonSnapshot({
    required String table,
    required String key,
    required DateTime start,
    required DateTime end,
    required Map<String, Object?> payload,
    String? moduleCode,
    String subjectId = GlucoseSubject.selfId,
  }) async {
    final database = await _db();
    final now = DateTime.now().millisecondsSinceEpoch;
    final values = <String, Object?>{
      'snapshot_key': key,
      'subject_id': subjectId,
      'window_start_ms': start.millisecondsSinceEpoch,
      'window_end_ms': end.millisecondsSinceEpoch,
      'payload_json': jsonEncode(payload),
      'updated_at_ms': now,
    };
    if (moduleCode != null) {
      values['module_code'] = moduleCode;
    }
    await database.insert(
      table,
      values,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<JsonSnapshot?> latest(
    String table, {
    String? moduleCode,
    String subjectId = GlucoseSubject.selfId,
  }) async {
    final database = await _db();
    final where =
        moduleCode == null
            ? 'subject_id = ?'
            : 'subject_id = ? AND module_code = ?';
    final whereArgs =
        moduleCode == null ? [subjectId] : [subjectId, moduleCode];
    final rows = await database.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: 'updated_at_ms DESC',
      limit: 1,
    );
    if (rows.isEmpty) return null;
    final row = rows.first;
    return JsonSnapshot(
      key: row['snapshot_key'] as String,
      windowStart: DateTime.fromMillisecondsSinceEpoch(
        row['window_start_ms'] as int,
      ),
      windowEnd: DateTime.fromMillisecondsSinceEpoch(
        row['window_end_ms'] as int,
      ),
      payload:
          (jsonDecode(row['payload_json'] as String) as Map)
              .cast<String, Object?>(),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        row['updated_at_ms'] as int,
      ),
    );
  }
}
