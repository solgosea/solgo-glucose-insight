import '../../../../../data/probe/platform/device_probe_platform_source.dart';
import '../../../../../data/probe/platform/device_probe_snapshot.dart';
import '../../../../../domain/probe/status_probe_context.dart';
import '../../../../../domain/probe/status_probe_definition.dart';
import '../../../../../domain/probe/status_probe_result.dart';
import '../../../../../domain/probe/status_probe_severity.dart';
import '../../../../../domain/probe/status_probe_signal.dart';
import '../../../../../domain/probe/status_probe_state.dart';
import '../../status_probe_result_helpers.dart';

typedef DeviceProbeEvaluator = StatusProbeResult Function(
  DeviceProbeSnapshot snapshot,
  StatusProbeDefinition definition,
  StatusProbeContext context,
);

class CommonDeviceProbeRunner {
  final DeviceProbePlatformSource source;

  const CommonDeviceProbeRunner({
    this.source = const DeviceProbePlatformSource(),
  });

  Future<StatusProbeResult> run(
    StatusProbeDefinition definition,
    StatusProbeContext context,
    DeviceProbeEvaluator evaluator,
  ) async {
    final snapshot = await source.query();
    if (snapshot.hasError) {
      return probeResult(
        definition: definition,
        state: StatusProbeState.unknown,
        observedAt: context.now,
        summary: 'Device check is not available',
        confidence: 0,
        signals: [
          StatusProbeSignal(
            label: 'Bridge',
            value: snapshot.error ?? 'Unavailable',
            severity: StatusProbeSeverity.watch,
          ),
        ],
        sourceRefs: [
          sourceRef(definition.id.value, 'deviceProbe.error', snapshot.error),
        ],
      );
    }
    return evaluator(snapshot, definition, context);
  }
}
