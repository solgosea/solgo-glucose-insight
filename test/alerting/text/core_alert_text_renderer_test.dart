import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/alerting/application/rule/evaluators/glucose_high_rule_evaluator.dart';
import 'package:smart_xdrip/alerting/application/rule/evaluators/glucose_rapid_fall_rule_evaluator.dart';
import 'package:smart_xdrip/alerting/application/rule/alert_rule_evaluator.dart';
import 'package:smart_xdrip/alerting/application/text/alert_text_render_context.dart';
import 'package:smart_xdrip/alerting/application/text/alert_text_render_request.dart';
import 'package:smart_xdrip/alerting/application/text/renderers/core_glucose_alert_text_renderer.dart';
import 'package:smart_xdrip/alerting/application/text/renderers/core_rate_alert_text_renderer.dart';
import 'package:smart_xdrip/alerting/domain/event/alert_category.dart';
import 'package:smart_xdrip/alerting/domain/event/alert_event_source.dart';
import 'package:smart_xdrip/alerting/domain/event/alert_level.dart';
import 'package:smart_xdrip/alerting/domain/rule/alert_rule.dart';
import 'package:smart_xdrip/alerting/domain/rule/alert_rule_comparator.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';

void main() {
  test('core glucose renderer formats mg/dL from structured mmol value', () {
    final result = const GlucoseHighRuleEvaluator().evaluate(
      _rule(
        category: AlertCategory.glucoseHigh,
        comparator: AlertRuleComparator.greaterThan,
        threshold: 10,
      ),
      AlertRuleEvaluationContext(
        readings: [
          GlucoseReading(timestamp: DateTime(2026, 6, 13, 8), value: 10.8),
        ],
        now: DateTime(2026, 6, 13, 8, 1),
      ),
    );

    final rendered = const CoreGlucoseAlertTextRenderer().render(
      AlertTextRenderRequest(
        source: AlertEventSource.nightscout,
        category: AlertCategory.glucoseHigh,
        type: 'high',
        result: result,
      ),
      const AlertTextRenderContext(unit: GlucoseUnit.mgDl),
    );

    expect(rendered.body, 'Glucose is 194 mg/dL.');
  });

  test('core rate renderer formats mg/dL/min from structured rate', () {
    final result = const GlucoseRapidFallRuleEvaluator().evaluate(
      _rule(
        category: AlertCategory.glucoseRapidFall,
        comparator: AlertRuleComparator.rateBelow,
        threshold: -0.1,
      ),
      AlertRuleEvaluationContext(
        readings: [
          GlucoseReading(
            timestamp: DateTime(2026, 6, 13, 8),
            value: 6,
            ratePerMin: -0.17,
          ),
        ],
        now: DateTime(2026, 6, 13, 8, 1),
      ),
    );

    final rendered = const CoreRateAlertTextRenderer().render(
      AlertTextRenderRequest(
        source: AlertEventSource.nightscout,
        category: AlertCategory.glucoseRapidFall,
        type: 'rapidFall',
        result: result,
      ),
      const AlertTextRenderContext(unit: GlucoseUnit.mgDl),
    );

    expect(rendered.body, 'Glucose is falling quickly (-3.1 mg/dL/min).');
  });

  test('core glucose renderer follows Chinese locale', () {
    final result = const GlucoseHighRuleEvaluator().evaluate(
      _rule(
        category: AlertCategory.glucoseHigh,
        comparator: AlertRuleComparator.greaterThan,
        threshold: 10,
      ),
      AlertRuleEvaluationContext(
        readings: [
          GlucoseReading(timestamp: DateTime(2026, 6, 13, 8), value: 10.8),
        ],
        now: DateTime(2026, 6, 13, 8, 1),
      ),
    );

    final rendered = const CoreGlucoseAlertTextRenderer().render(
      AlertTextRenderRequest(
        source: AlertEventSource.nightscout,
        category: AlertCategory.glucoseHigh,
        type: 'high',
        result: result,
      ),
      const AlertTextRenderContext(
        unit: GlucoseUnit.mmolL,
        locale: Locale('zh'),
      ),
    );

    expect(rendered.title, '高血糖');
    expect(rendered.body, '血糖为 10.8 mmol/L。');
  });
}

AlertRule _rule({
  required AlertCategory category,
  required AlertRuleComparator comparator,
  required double threshold,
}) {
  final now = DateTime(2026, 6, 13, 8);
  return AlertRule(
    id: 'rule-${category.name}',
    ruleSetId: 'self',
    category: category,
    enabled: true,
    comparator: comparator,
    thresholdValue: threshold,
    thresholdUnit: 'mmol/L',
    level: AlertLevel.warning,
    channels: const {},
    soundPolicy: null,
    repeatMinutes: 0,
    priority: 10,
    metadata: const {},
    createdAt: now,
    updatedAt: now,
  );
}
