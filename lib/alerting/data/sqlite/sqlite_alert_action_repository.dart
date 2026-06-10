import 'package:sqflite/sqflite.dart';

import '../../alerting_tables.dart';
import '../../domain/action/alert_action.dart';
import '../../domain/repository/alert_action_repository.dart';
import '../../shared/alert_id_generator.dart';

class SqliteAlertActionRepository implements AlertActionRepository {
  final Future<Database> Function() databaseProvider;
  final AlertIdGenerator idGenerator;

  const SqliteAlertActionRepository({
    required this.databaseProvider,
    this.idGenerator = const AlertIdGenerator(),
  });

  @override
  Future<void> insertAction({
    required String alertEventId,
    required AlertAction action,
    required String actor,
    String? note,
  }) async {
    final now = DateTime.now();
    final database = await databaseProvider();
    await database.insert(AlertingTables.actionLogs, {
      'id': idGenerator.newId('action'),
      'alert_event_id': alertEventId,
      'action': action.name,
      'actor': actor,
      'note': note,
      'created_at': now.toIso8601String(),
    });
  }

  @override
  Future<void> insertSnooze({
    required String alertEventId,
    required DateTime snoozedUntil,
    String? targetId,
    String? alertType,
    String? source,
    String? category,
    String? level,
    String? reason,
  }) async {
    final now = DateTime.now();
    final database = await databaseProvider();
    await database.insert(AlertingTables.snoozeRules, {
      'id': idGenerator.newId('snooze'),
      'alert_event_id': alertEventId,
      'target_id': targetId,
      'alert_type': alertType,
      'source': source,
      'category': category,
      'level': level,
      'snoozed_until': snoozedUntil.toIso8601String(),
      'reason': reason,
      'created_at': now.toIso8601String(),
      'updated_at': now.toIso8601String(),
    });
  }

  @override
  Future<DateTime?> activeSnoozeUntil({
    required String targetId,
    required String alertType,
    required DateTime now,
  }) async {
    final database = await databaseProvider();
    final rows = await database.query(
      AlertingTables.snoozeRules,
      columns: ['snoozed_until'],
      where: 'target_id = ? AND alert_type = ? AND snoozed_until > ?',
      whereArgs: [targetId, alertType, now.toIso8601String()],
      orderBy: 'snoozed_until DESC',
      limit: 1,
    );
    if (rows.isEmpty) return null;
    final raw = rows.first['snoozed_until'] as String?;
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }
}
