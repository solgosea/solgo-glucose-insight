import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/rule_catalogs/cgm_sensor_rule_catalog.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/rule_catalogs/nightscout_rule_catalog.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/rule_catalogs/xdrip_rule_catalog.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/rule_engine/status_rule_engine.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/rule_engine/status_rule_score_policy.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/analysis/status_data_quality.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/analysis/status_rule_explanation.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/analysis/status_rule_id.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/analysis/status_rule_result.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/rules/status_rule_availability.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/rules/status_rule_definition.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/rules/status_rule_input_requirement.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_component_kind.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_level.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_metric.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_metric_source.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/test_support/fake_status_rule_catalog_factory.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/test_support/fake_status_rule_context_factory.dart';

void main() {
  test('component catalogs expose expected rule definitions', () {
    final cgm = const CgmSensorRuleCatalog().build().definitions;
    final xdrip = const XdripRuleCatalog().build().definitions;
    final nightscout = const NightscoutRuleCatalog().build().definitions;

    expect(cgm, hasLength(6));
    expect(xdrip, hasLength(6));
    expect(nightscout, hasLength(5));
    expect(
      cgm.map((definition) => definition.weight).reduce((a, b) => a + b),
      100,
    );
    expect(
      xdrip.map((definition) => definition.weight).reduce((a, b) => a + b),
      100,
    );
    expect(
      nightscout.map((definition) => definition.weight).reduce((a, b) => a + b),
      100,
    );
  });

  test('rule engine normalizes affectsComponentLevel from catalog', () async {
    final definition = _definition(affectsComponentLevel: false);
    final result = _result(affectsComponentLevel: true);
    final registry = const FakeStatusRuleCatalogFactory().single(
      definition: definition,
      result: result,
    );

    final results = await const StatusRuleEngine().evaluate(
      registry: registry,
      context: const FakeStatusRuleContextFactory().build(),
    );

    expect(results.single.affectsComponentLevel, isFalse);
  });

  test('score policy excludes unavailable and non-level-affecting metrics', () {
    final definitions = [
      _definition(ruleId: 'healthy', metricId: 'healthy', weight: 50),
      _definition(ruleId: 'unknown', metricId: 'unknown', weight: 50),
      _definition(
        ruleId: 'context',
        metricId: 'context',
        weight: 50,
        affectsComponentLevel: false,
      ),
    ];
    final score = const StatusRuleScorePolicy().calculate(
      definitions: definitions,
      results: [
        _result(ruleId: 'healthy', metricId: 'healthy'),
        _result(
          ruleId: 'unknown',
          metricId: 'unknown',
          metric: const StatusMetric.unknown(
            id: 'unknown',
            label: 'Unknown',
            source: StatusMetricSource.localProbe,
            reason: 'Missing',
          ),
          level: StatusLevel.unknown,
        ),
        _result(
          ruleId: 'context',
          metricId: 'context',
          affectsComponentLevel: false,
        ),
      ],
      labelFor: (value) => value == null ? 'No data' : 'Score $value',
    );

    expect(score.value, 100);
    expect(score.label, 'Score 100');
    expect(score.availableSignals, 1);
    expect(score.totalSignals, 3);
    expect(score.confidence, closeTo(1 / 3, 0.001));
  });
}

StatusRuleDefinition _definition({
  String ruleId = 'test.rule',
  String metricId = 'test_metric',
  double weight = 10,
  bool affectsComponentLevel = true,
}) {
  return StatusRuleDefinition(
    ruleId: StatusRuleId(ruleId),
    componentKind: StatusComponentKind.cgmSensor,
    metricId: metricId,
    inputRequirements: const [StatusRuleInputRequirement.currentSource],
    thresholdBands: const [],
    weight: weight,
    affectsComponentLevel: affectsComponentLevel,
    unavailableBehavior: StatusRuleAvailability.unknownWhenMissing,
    textTemplateKey: 'test.template',
  );
}

StatusRuleResult _result({
  String ruleId = 'test.rule',
  String metricId = 'test_metric',
  StatusMetric? metric,
  StatusLevel level = StatusLevel.healthy,
  bool affectsComponentLevel = true,
}) {
  return StatusRuleResult(
    ruleId: StatusRuleId(ruleId),
    metric: metric ??
        StatusMetric(
          id: metricId,
          label: 'Metric',
          valueLabel: 'Healthy',
          level: level,
          source: StatusMetricSource.localProbe,
        ),
    level: level,
    dataQuality: StatusDataQuality.normal,
    explanation: const StatusRuleExplanation(
      summary: 'OK',
      detail: 'OK',
    ),
    affectsComponentLevel: affectsComponentLevel,
  );
}
