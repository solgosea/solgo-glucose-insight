import '../../probe/history/status_probe_history_recorder.dart';
import '../engine/status_probe_scenario_execution_state.dart';
import '../engine/status_probe_scenario_step.dart';

class PersistScenarioHistoryStep implements StatusProbeScenarioStep {
  final StatusProbeHistoryRecorder? historyRecorder;

  const PersistScenarioHistoryStep({this.historyRecorder});

  @override
  String get id => 'persistHistory';

  @override
  Future<StatusProbeScenarioExecutionState> execute(
    StatusProbeScenarioExecutionState state,
  ) async {
    final bundle = state.bundle;
    if (bundle != null) {
      await historyRecorder?.record(
        context: state.input.context,
        bundle: bundle,
      );
    }
    return state;
  }
}
