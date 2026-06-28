import '../../../domain/probe/status_probe_catalog.dart';
import '../../../domain/probe/status_probe_evidence_bundle.dart';
import '../../../domain/probe/status_probe_suite_result.dart';
import '../../../domain/probe_scenario/status_probe_scenario_definition.dart';
import '../../../domain/probe_scenario/status_probe_scenario_plan.dart';
import '../../../domain/probe_scenario/status_probe_scenario_result.dart';
import '../../../domain/probe_scenario/status_probe_scenario_score_breakdown.dart';
import 'status_probe_scenario_engine_input.dart';

class StatusProbeScenarioExecutionState {
  final StatusProbeScenarioEngineInput input;
  final StatusProbeCatalog? catalog;
  final StatusProbeScenarioDefinition? scenario;
  final StatusProbeScenarioPlan? plan;
  final List<StatusProbeSuiteResult> suiteResults;
  final StatusProbeEvidenceBundle? bundle;
  final StatusProbeScenarioScoreBreakdown? breakdown;
  final StatusProbeScenarioResult? result;
  final Object? error;

  const StatusProbeScenarioExecutionState({
    required this.input,
    this.catalog,
    this.scenario,
    this.plan,
    this.suiteResults = const [],
    this.bundle,
    this.breakdown,
    this.result,
    this.error,
  });

  StatusProbeScenarioExecutionState copyWith({
    StatusProbeCatalog? catalog,
    StatusProbeScenarioDefinition? scenario,
    StatusProbeScenarioPlan? plan,
    List<StatusProbeSuiteResult>? suiteResults,
    StatusProbeEvidenceBundle? bundle,
    StatusProbeScenarioScoreBreakdown? breakdown,
    StatusProbeScenarioResult? result,
    Object? error,
  }) {
    return StatusProbeScenarioExecutionState(
      input: input,
      catalog: catalog ?? this.catalog,
      scenario: scenario ?? this.scenario,
      plan: plan ?? this.plan,
      suiteResults: suiteResults ?? this.suiteResults,
      bundle: bundle ?? this.bundle,
      breakdown: breakdown ?? this.breakdown,
      result: result ?? this.result,
      error: error,
    );
  }
}
