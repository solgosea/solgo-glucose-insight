import 'dart:convert';

import 'package:sqflite/sqflite.dart';

import '../../alerting_tables.dart';
import '../../domain/config/alert_strategy_config.dart';
import '../../domain/config/alerting_global_config.dart';
import '../../domain/config/in_app_alert_config.dart';
import '../../domain/config/local_notification_alert_config.dart';
import '../../domain/config/sound_alert_config.dart';
import '../../domain/config/vibration_alert_config.dart';
import '../../domain/repository/alert_strategy_config_repository.dart';

class SqliteAlertStrategyConfigRepository
    implements AlertStrategyConfigRepository {
  final Future<Database> Function() databaseProvider;

  const SqliteAlertStrategyConfigRepository({required this.databaseProvider});

  @override
  Future<AlertStrategyConfigSet> load() async {
    await _ensureDefaults();
    final database = await databaseProvider();
    final rows = await database.query(AlertingTables.strategyConfigs);
    final byKey = {for (final row in rows) row['strategy_key'] as String: row};

    return AlertStrategyConfigSet(
      global: AlertingGlobalConfig.fromJson(
        _payload(byKey[AlertingGlobalConfig.strategyKey]),
      ),
      inApp: InAppAlertConfig.fromJson(_payload(byKey[InAppAlertConfig.key])),
      localNotification: LocalNotificationAlertConfig.fromJson(
        _payload(byKey[LocalNotificationAlertConfig.key]),
      ),
      sound: SoundAlertConfig.fromJson(_payload(byKey[SoundAlertConfig.key])),
      vibration: VibrationAlertConfig.fromJson(
        _payload(byKey[VibrationAlertConfig.key]),
      ),
    );
  }

  @override
  Future<void> saveGlobal(AlertingGlobalConfig config) =>
      _save(AlertingGlobalConfig.strategyKey, config.enabled, config.toJson());

  @override
  Future<void> save(AlertStrategyConfig config) =>
      _save(config.strategyKey, config.enabled, config.toJson());

  Future<void> _ensureDefaults() async {
    final database = await databaseProvider();
    final count =
        Sqflite.firstIntValue(
          await database.rawQuery(
            'SELECT COUNT(*) FROM ${AlertingTables.strategyConfigs}',
          ),
        ) ??
        0;
    if (count > 0) return;
    await saveGlobal(const AlertingGlobalConfig());
    await save(const InAppAlertConfig());
    await save(const LocalNotificationAlertConfig());
    await save(const SoundAlertConfig());
    await save(const VibrationAlertConfig());
  }

  Future<void> _save(
    String key,
    bool enabled,
    Map<String, Object?> config,
  ) async {
    final database = await databaseProvider();
    await database.insert(AlertingTables.strategyConfigs, {
      'strategy_key': key,
      'enabled': enabled ? 1 : 0,
      'config_json': jsonEncode(config),
      'updated_at': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Map<String, Object?> _payload(Map<String, Object?>? row) {
    if (row == null) return const {};
    final raw = row['config_json'] as String?;
    if (raw == null || raw.isEmpty) return const {};
    final decoded = jsonDecode(raw);
    if (decoded is Map) return decoded.cast<String, Object?>();
    return const {};
  }
}
