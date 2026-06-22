import 'package:sqflite/sqflite.dart';

import '../../domain/detail/status_endpoint_probe.dart';
import '../../domain/detail/status_response_time_point.dart';
import '../../domain/status_level.dart';
import 'status_monitor_schema.dart';
import 'status_monitor_tables.dart';

class StatusMonitorProbeRepository {
  final Future<Database> Function() databaseProvider;
  bool _schemaReady = false;

  StatusMonitorProbeRepository({required this.databaseProvider});

  Future<Database> get _database async {
    final database = await databaseProvider();
    if (!_schemaReady) {
      await const StatusMonitorSchema().install(database);
      _schemaReady = true;
    }
    return database;
  }

  Future<void> saveSamples({
    required String subjectId,
    required String? sourceTargetId,
    required List<StatusEndpointProbe> probes,
  }) async {
    if (probes.isEmpty) return;
    final database = await _database;
    final batch = database.batch();
    for (final probe in probes) {
      batch.insert(StatusMonitorTables.probeSamples, {
        'subject_id': subjectId,
        'source_target_id': sourceTargetId,
        'endpoint': probe.endpoint,
        'level': probe.level.name,
        'reachable': probe.reachable ? 1 : 0,
        'status_code': probe.statusCode,
        'elapsed_ms': probe.elapsed.inMilliseconds,
        'at_ms': probe.checkedAt.millisecondsSinceEpoch,
      });
    }
    await batch.commit(noResult: true);
  }

  Future<List<StatusResponseTimePoint>> latestResponsePoints({
    required String subjectId,
    required String endpoint,
    int limit = 30,
  }) async {
    final database = await _database;
    final rows = await database.query(
      StatusMonitorTables.probeSamples,
      where: 'subject_id = ? AND endpoint = ?',
      whereArgs: [subjectId, endpoint],
      orderBy: 'at_ms DESC',
      limit: limit,
    );
    return rows.map(_pointFromRow).toList(growable: false).reversed.toList();
  }

  StatusResponseTimePoint _pointFromRow(Map<String, Object?> row) {
    final levelName = row['level']?.toString();
    final level = StatusLevel.values.firstWhere(
      (value) => value.name == levelName,
      orElse: () => StatusLevel.unknown,
    );
    return StatusResponseTimePoint(
      at: DateTime.fromMillisecondsSinceEpoch(row['at_ms'] as int),
      elapsed: Duration(milliseconds: row['elapsed_ms'] as int),
      level: level,
      timeout: row['reachable'] != 1,
      endpoint: row['endpoint']?.toString() ?? '',
    );
  }
}
