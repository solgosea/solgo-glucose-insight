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

class BluetoothPermissionProbe implements StatusProbeDriver {
  final CommonDeviceProbeRunner runner;

  BluetoothPermissionProbe({CommonDeviceProbeRunner? runner})
      : runner = runner ?? const CommonDeviceProbeRunner();

  @override
  StatusProbeDefinition get definition => const StatusProbeDefinition(
        id: StatusProbeId('common.bluetooth.permission'),
        suiteId: 'common',
        label: 'Bluetooth permission',
        kind: StatusProbeKind.common,
        category: StatusProbeCategory.permission,
        runMode: StatusProbeRunMode.active,
      );

  @override
  Future<StatusProbeResult> run(StatusProbeContext context) {
    return runner.run(definition, context, (snapshot, definition, context) {
      final granted = snapshot.bluetoothPermissionGranted;
      return probeResult(
        definition: definition,
        state: granted ? StatusProbeState.healthy : StatusProbeState.watch,
        observedAt: snapshot.checkedAt,
        summary: granted
            ? 'Bluetooth permission is available'
            : 'Bluetooth permission is limited',
        confidence: granted ? 1 : 0.5,
        signals: [signal('Permission', granted ? 'yes' : 'no')],
        sourceRefs: [
          sourceRef(definition.id.value, 'android.permission.bluetooth')
        ],
      );
    });
  }
}
