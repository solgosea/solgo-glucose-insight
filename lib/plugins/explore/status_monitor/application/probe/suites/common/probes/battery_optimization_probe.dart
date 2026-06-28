import '../../../../../domain/probe/status_probe_category.dart';
import '../../../../../domain/probe/status_probe_context.dart';
import '../../../../../domain/probe/status_probe_definition.dart';
import '../../../../../domain/probe/status_probe_id.dart';
import '../../../../../domain/probe/status_probe_kind.dart';
import '../../../../../domain/probe/status_probe_result.dart';
import '../../../../../domain/probe/status_probe_run_mode.dart';
import '../../../../../domain/probe/status_probe_state.dart';
import '../../../contracts/status_probe_driver.dart';
import '../../status_probe_result_helpers.dart';
import 'common_device_probe_helpers.dart';

class BatteryOptimizationProbe implements StatusProbeDriver {
  final CommonDeviceProbeRunner runner;

  BatteryOptimizationProbe({CommonDeviceProbeRunner? runner})
      : runner = runner ?? const CommonDeviceProbeRunner();

  @override
  StatusProbeDefinition get definition => const StatusProbeDefinition(
        id: StatusProbeId('common.battery.optimization'),
        suiteId: 'common',
        label: 'Battery optimization',
        kind: StatusProbeKind.common,
        category: StatusProbeCategory.power,
        runMode: StatusProbeRunMode.active,
      );

  @override
  Future<StatusProbeResult> run(StatusProbeContext context) {
    return runner.run(definition, context, (snapshot, definition, context) {
      final unrestricted = snapshot.batteryOptimizationIgnored;
      return probeResult(
        definition: definition,
        state: unrestricted ? StatusProbeState.healthy : StatusProbeState.watch,
        observedAt: snapshot.checkedAt,
        summary: unrestricted
            ? 'Battery optimization is not restricting the app'
            : 'Battery optimization may restrict background checks',
        confidence: unrestricted ? 1 : 0.55,
        signals: [
          signal('Unrestricted', unrestricted ? 'yes' : 'no'),
          signal('Power save', snapshot.powerSaveMode ? 'yes' : 'no'),
        ],
        sourceRefs: [sourceRef(definition.id.value, 'android.power')],
      );
    });
  }
}
