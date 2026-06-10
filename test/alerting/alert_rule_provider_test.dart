import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/alerting/application/rule/alert_rule_defaults.dart';
import 'package:smart_xdrip/alerting/application/rule/alert_rule_provider.dart';
import 'package:smart_xdrip/alerting/data/sqlite/sqlite_alert_rule_repository.dart';
import 'package:smart_xdrip/alerting/domain/event/alert_category.dart';
import 'package:smart_xdrip/alerting/domain/rule/glucose_alert_default_thresholds.dart';
import 'package:smart_xdrip/domain/subject/glucose_subject.dart';

import '../_support/test_database.dart';

void main() {
  test(
    'initializes self default alert rules in Alerting Core tables',
    () async {
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

      expect(
        rules.map((rule) => rule.category),
        contains(AlertCategory.glucoseLow),
      );
      final urgentLow = rules.singleWhere(
        (rule) => rule.category == AlertCategory.glucoseUrgentLow,
      );
      final low = rules.singleWhere(
        (rule) => rule.category == AlertCategory.glucoseLow,
      );
      final high = rules.singleWhere(
        (rule) => rule.category == AlertCategory.glucoseHigh,
      );
      final rapidFall = rules.singleWhere(
        (rule) => rule.category == AlertCategory.glucoseRapidFall,
      );
      final noData = rules.singleWhere(
        (rule) => rule.category == AlertCategory.noData,
      );

      expect(
        urgentLow.thresholdValue,
        GlucoseAlertDefaultThresholds.urgentLowMmol,
      );
      expect(low.thresholdValue, GlucoseAlertDefaultThresholds.lowMmol);
      expect(high.thresholdValue, GlucoseAlertDefaultThresholds.highMmol);
      expect(high.enabled, isTrue);
      expect(
        rapidFall.thresholdValue,
        GlucoseAlertDefaultThresholds.rapidFallRateMmolPerMin,
      );
      expect(
        noData.thresholdValue,
        GlucoseAlertDefaultThresholds.noDataMinutes,
      );
      expect(
        await repository.ruleSetByKey(
          AlertRuleDefaults.selfDefaultRuleSetKey,
          subjectId: GlucoseSubject.selfId,
        ),
        isNotNull,
      );
    },
  );
}
