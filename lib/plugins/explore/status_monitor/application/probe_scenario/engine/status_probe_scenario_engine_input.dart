import '../../../domain/probe/status_probe_context.dart';

class StatusProbeScenarioEngineInput {
  final StatusProbeContext context;
  final String scenarioId;

  const StatusProbeScenarioEngineInput({
    required this.context,
    required this.scenarioId,
  });
}
