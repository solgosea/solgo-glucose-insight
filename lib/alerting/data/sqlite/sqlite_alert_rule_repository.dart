import 'package:sqflite/sqflite.dart';

import '../../alerting_tables.dart';
import '../../domain/repository/alert_rule_repository.dart';
import '../../domain/rule/alert_rule.dart';
import '../../domain/rule/alert_rule_set.dart';
import 'mappers/alert_rule_row_mapper.dart';
import 'mappers/alert_rule_set_row_mapper.dart';

class SqliteAlertRuleRepository implements AlertRuleRepository {
  final Future<Database> Function() databaseProvider;
  final AlertRuleSetRowMapper ruleSetMapper;
  final AlertRuleRowMapper ruleMapper;

  const SqliteAlertRuleRepository({
    required this.databaseProvider,
    this.ruleSetMapper = const AlertRuleSetRowMapper(),
    this.ruleMapper = const AlertRuleRowMapper(),
  });

  @override
  Future<AlertRuleSet?> ruleSetByKey(
    String ruleSetKey, {
    String? subjectId,
  }) async {
    final database = await databaseProvider();
    final rows = await database.query(
      AlertingTables.ruleSets,
      where:
          subjectId == null
              ? 'rule_set_key = ? AND subject_id IS NULL'
              : 'rule_set_key = ? AND subject_id = ?',
      whereArgs: subjectId == null ? [ruleSetKey] : [ruleSetKey, subjectId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return ruleSetMapper.fromRow(rows.first);
  }

  @override
  Future<List<AlertRule>> rulesForSet(String ruleSetId) async {
    final database = await databaseProvider();
    final rows = await database.query(
      AlertingTables.rules,
      where: 'rule_set_id = ?',
      whereArgs: [ruleSetId],
      orderBy: 'priority DESC, category ASC',
    );
    return rows.map(ruleMapper.fromRow).toList(growable: false);
  }

  @override
  Future<void> upsertRuleSet(AlertRuleSet ruleSet) async {
    final database = await databaseProvider();
    await database.insert(
      AlertingTables.ruleSets,
      ruleSetMapper.toRow(ruleSet),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> upsertRules(List<AlertRule> rules) async {
    if (rules.isEmpty) return;
    final database = await databaseProvider();
    await database.transaction((txn) async {
      for (final rule in rules) {
        await txn.insert(
          AlertingTables.rules,
          ruleMapper.toRow(rule),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }
}
