import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/alerting/application/rule/alert_rule_provider.dart';
import 'package:smart_xdrip/alerting/data/sqlite/sqlite_alert_rule_repository.dart';
import 'package:smart_xdrip/alerting/domain/event/alert_category.dart';
import 'package:smart_xdrip/alerting/domain/rule/alert_rule.dart';
import 'package:smart_xdrip/alerting/domain/source/alert_input.dart';
import 'package:smart_xdrip/alerting/domain/source/alert_source_sink.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/domain/subject/glucose_subject.dart';
import 'package:smart_xdrip/plugins/profile/alert_source/local_glucose_alert_source.dart';

import '../../_support/test_database.dart';

void main() {
  test('local datasource alerts follow Alerting Core rules', () async {
    final database = await TestDatabase.createWithAlerting();
    addTearDown(database.close);
    final repository = SqliteAlertRuleRepository(
      databaseProvider: () => database.db,
    );
    final provider = AlertRuleProvider(
      repository: repository,
      clock: () => DateTime(2026, 6, 9, 8),
    );
    final rules = await provider.selfDefaultRules(GlucoseSubject.selfId);
    await repository.upsertRules(
      rules.map((rule) {
        if (rule.category == AlertCategory.glucoseUrgentLow ||
            rule.category == AlertCategory.glucoseLow) {
          return _withThreshold(rule, 2.9);
        }
        return rule;
      }).toList(growable: false),
    );
    final now = DateTime(2026, 6, 9, 8, 0);
    await database.upsertMany([GlucoseReading(timestamp: now, value: 3.4)]);
    final sink = _CollectingSink();
    final source = LocalGlucoseAlertSource(
      database: database,
      settingsProvider: () => const AppSettings(
        nightscoutBaseUrl: 'https://demo.fly.dev',
        nightscoutSyncEnabled: true,
      ),
      subjectIdProvider: () => GlucoseSubject.selfId,
      ruleProvider: provider,
      clock: () => now.add(const Duration(minutes: 1)),
    );

    await source.start(sink);
    await source.evaluateCurrentSubject();

    expect(sink.inputs, isEmpty);
  });
}

AlertRule _withThreshold(AlertRule rule, double threshold) {
  return AlertRule(
    id: rule.id,
    ruleSetId: rule.ruleSetId,
    category: rule.category,
    enabled: rule.enabled,
    comparator: rule.comparator,
    thresholdValue: threshold,
    thresholdUnit: rule.thresholdUnit,
    level: rule.level,
    channels: rule.channels,
    soundPolicy: rule.soundPolicy,
    repeatMinutes: rule.repeatMinutes,
    priority: rule.priority,
    metadata: rule.metadata,
    createdAt: rule.createdAt,
    updatedAt: DateTime(2026, 6, 9, 8, 1),
  );
}

class _CollectingSink implements AlertSourceSink {
  final inputs = <AlertInput>[];

  @override
  Future<void> ingest(AlertInput input) async {
    inputs.add(input);
  }
}
