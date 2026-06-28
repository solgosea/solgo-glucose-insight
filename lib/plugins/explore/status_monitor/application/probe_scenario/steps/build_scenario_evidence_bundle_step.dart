import '../../probe/builders/status_probe_evidence_bundle_builder.dart';
import '../engine/status_probe_scenario_execution_state.dart';
import '../engine/status_probe_scenario_step.dart';

class BuildScenarioEvidenceBundleStep implements StatusProbeScenarioStep {
  final StatusProbeEvidenceBundleBuilder bundleBuilder;
  final DateTime Function() now;

  const BuildScenarioEvidenceBundleStep({
    this.bundleBuilder = const StatusProbeEvidenceBundleBuilder(),
    required this.now,
  });

  @override
  String get id => 'buildEvidenceBundle';

  @override
  Future<StatusProbeScenarioExecutionState> execute(
    StatusProbeScenarioExecutionState state,
  ) async {
    return state.copyWith(
      bundle: bundleBuilder.build(
        subjectId: state.input.context.subjectId,
        generatedAt: now(),
        suites: state.suiteResults,
      ),
    );
  }
}
