import '../../../domain/probe/status_probe_result.dart';
import '../../../domain/probe/status_probe_state.dart';
import '../../../domain/probe_scenario/status_probe_scenario_plan_item.dart';

class StatusProbeGateRuleEvaluator {
  const StatusProbeGateRuleEvaluator();

  bool failed(StatusProbeScenarioPlanItem item, StatusProbeResult? result) {
    if (!item.hardGate) return false;
    return result?.state != StatusProbeState.healthy;
  }
}
