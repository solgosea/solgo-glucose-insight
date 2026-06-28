import 'package:sqflite/sqflite.dart';

import '../../../application/probe/contracts/status_probe_history_repository.dart';
import '../../../domain/probe/status_probe_history_sample.dart';
import '../../sqlite/status_monitor_schema.dart';
import '../../sqlite/status_monitor_tables.dart';
import 'status_probe_sample_row_mapper.dart';

class SqliteStatusProbeHistoryRepository
    implements StatusProbeHistoryRepository {
  final Future<Database> Function() databaseProvider;
  final StatusProbeSampleRowMapper mapper;
  bool _schemaReady = false;

  SqliteStatusProbeHistoryRepository({
    required this.databaseProvider,
    this.mapper = const StatusProbeSampleRowMapper(),
  });

  Future<Database> get _database async {
    final database = await databaseProvider();
    if (!_schemaReady) {
      await const StatusMonitorSchema().install(database);
      _schemaReady = true;
    }
    return database;
  }

  @override
  Future<void> save(StatusProbeHistorySample sample) async {
    final database = await _database;
    await database.insert(
      StatusMonitorTables.probeSamples,
      mapper.toRow(sample),
    );
  }

  @override
  Future<List<StatusProbeHistorySample>> latest({
    required String subjectId,
    required String probeId,
    int limit = 20,
  }) async {
    final database = await _database;
    final rows = await database.query(
      StatusMonitorTables.probeSamples,
      where: 'subject_id = ? AND (probe_id = ? OR endpoint = ?)',
      whereArgs: [subjectId, probeId, probeId],
      orderBy: 'at_ms DESC',
      limit: limit,
    );
    return rows.map(mapper.fromRow).toList(growable: false);
  }
}
