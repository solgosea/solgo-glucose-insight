import '../../../domain/probe/status_probe_suite_result.dart';
import '../../../domain/probe_scenario/status_probe_scenario_plan.dart';
import '../../../domain/probe_scenario/status_probe_scenario_score_breakdown.dart';
import 'status_probe_weighted_score_calculator.dart';

class StatusProbeScenarioScoreEngine {
  final StatusProbeWeightedScoreCalculator calculator;

  const StatusProbeScenarioScoreEngine({
    this.calculator = const StatusProbeWeightedScoreCalculator(),
  });

  StatusProbeScenarioScoreBreakdown score({
    required StatusProbeScenarioPlan plan,
    required Iterable<StatusProbeSuiteResult> suites,
  }) {
    return calculator.calculate(
      plan: plan,
      results: suites.expand((suite) => suite.results),
    );
  }
}
