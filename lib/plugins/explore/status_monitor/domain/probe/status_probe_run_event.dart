import 'status_probe_result.dart';
import 'status_probe_run_event_type.dart';
import 'status_probe_suite_result.dart';
import '../probe_scenario/status_probe_scenario_result.dart';

class StatusProbeRunEvent {
  final StatusProbeRunEventType type;
  final String scenarioId;
  final String? suiteId;
  final String? probeId;
  final StatusProbeResult? result;
  final StatusProbeSuiteResult? suiteResult;
  final StatusProbeScenarioResult? scenarioResult;
  final Object? error;
  final DateTime occurredAt;

  const StatusProbeRunEvent({
    required this.type,
    required this.scenarioId,
    this.suiteId,
    this.probeId,
    this.result,
    this.suiteResult,
    this.scenarioResult,
    this.error,
    required this.occurredAt,
  });
}
