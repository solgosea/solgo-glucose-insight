import 'package:sqflite/sqflite.dart';

import '../../domain/floating/status_floating_mode.dart';
import '../../domain/floating/status_floating_position.dart';
import '../../domain/floating/status_floating_settings.dart';
import 'status_monitor_schema.dart';
import 'status_monitor_tables.dart';

class SqliteStatusFloatingSettingsRepository {
  final Future<Database> Function() databaseProvider;
  bool _schemaReady = false;

  SqliteStatusFloatingSettingsRepository({
    required this.databaseProvider,
  });

  Future<Database> get _database async {
    final database = await databaseProvider();
    if (!_schemaReady) {
      await const StatusMonitorSchema().install(database);
      _schemaReady = true;
    }
    return database;
  }

  Future<StatusFloatingSettings> get() async {
    final database = await _database;
    final rows = await database.query(
      StatusMonitorTables.floatingSettings,
      where: 'id = 1',
      limit: 1,
    );
    if (rows.isEmpty) return StatusFloatingSettings.defaults();
    final row = rows.first;
    return StatusFloatingSettings(
      mode: StatusFloatingMode.fromCode(row['mode'] as String?),
      position: StatusFloatingPosition(
        x: row['x'] as int? ?? StatusFloatingPosition.defaultPosition.x,
        y: row['y'] as int? ?? StatusFloatingPosition.defaultPosition.y,
      ),
      collapsed: row['collapsed'] == 1,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        row['updated_at_ms'] as int? ?? 0,
      ),
    );
  }

  Future<void> save(StatusFloatingSettings settings) async {
    final database = await _database;
    await database.insert(
      StatusMonitorTables.floatingSettings,
      {
        'id': 1,
        'mode': settings.mode.code,
        'x': settings.position.x,
        'y': settings.position.y,
        'collapsed': settings.collapsed ? 1 : 0,
        'updated_at_ms': settings.updatedAt.millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
