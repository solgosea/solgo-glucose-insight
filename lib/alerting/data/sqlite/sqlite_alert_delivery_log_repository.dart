import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../../alerting_tables.dart';
import '../../domain/channel/alert_channel.dart';
import '../../domain/channel/alert_delivery_plan.dart';
import '../../domain/channel/alert_delivery_result.dart';
import '../../domain/channel/alert_delivery_state.dart';
import '../../domain/repository/alert_delivery_log_repository.dart';
import '../../shared/alert_id_generator.dart';

class SqliteAlertDeliveryLogRepository implements AlertDeliveryLogRepository {
  final Future<Database> Function() databaseProvider;
  final AlertIdGenerator idGenerator;

  const SqliteAlertDeliveryLogRepository({
    required this.databaseProvider,
    this.idGenerator = const AlertIdGenerator(),
  });

  @override
  Future<void> insertPlan(AlertDeliveryPlan plan) async {
    final database = await databaseProvider();
    await database.insert(AlertingTables.deliveryPlans, {
      'id': plan.id,
      'alert_event_id': plan.event.id,
      'level': plan.event.level.name,
      'channels_json': jsonEncode(plan.channels.map((e) => e.code).toList()),
      'state': plan.state.name,
      'created_at': plan.createdAt.toIso8601String(),
      'updated_at': plan.updatedAt.toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> insertResult({
    required String alertEventId,
    required String? planId,
    required String strategyKey,
    required AlertDeliveryResult result,
  }) async {
    final status =
        result.skipped
            ? AlertDeliveryState.skipped
            : result.success
            ? AlertDeliveryState.delivered
            : AlertDeliveryState.failed;
    final now = DateTime.now();
    final database = await databaseProvider();
    await database.insert(AlertingTables.deliveryLogs, {
      'id': idGenerator.newId('delivery'),
      'alert_event_id': alertEventId,
      'plan_id': planId,
      'channel': result.channel.code,
      'strategy_key': strategyKey,
      'status': status.name,
      'message': result.message,
      'result_json': jsonEncode(result.result),
      'attempted_at': now.toIso8601String(),
      'completed_at': now.toIso8601String(),
    });
  }

  @override
  Future<void> insertSkipped({
    required String alertEventId,
    required String? planId,
    required String strategyKey,
    required AlertChannel channel,
    required String message,
  }) {
    return insertResult(
      alertEventId: alertEventId,
      planId: planId,
      strategyKey: strategyKey,
      result: AlertDeliveryResult.skipped(channel: channel, message: message),
    );
  }

  @override
  Future<List<Map<String, Object?>>> latestForEvent(String alertEventId) async {
    final database = await databaseProvider();
    return database.query(
      AlertingTables.deliveryLogs,
      where: 'alert_event_id = ?',
      whereArgs: [alertEventId],
      orderBy: 'attempted_at DESC',
    );
  }
}
