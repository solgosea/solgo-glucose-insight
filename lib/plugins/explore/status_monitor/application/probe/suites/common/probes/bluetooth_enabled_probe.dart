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

class BluetoothEnabledProbe implements StatusProbeDriver {
  final CommonDeviceProbeRunner runner;

  BluetoothEnabledProbe({CommonDeviceProbeRunner? runner})
      : runner = runner ?? const CommonDeviceProbeRunner();

  @override
  StatusProbeDefinition get definition => const StatusProbeDefinition(
        id: StatusProbeId('common.bluetooth.enabled'),
        suiteId: 'common',
        label: 'Bluetooth enabled',
        kind: StatusProbeKind.common,
        category: StatusProbeCategory.bluetooth,
        runMode: StatusProbeRunMode.active,
      );

  @override
  Future<StatusProbeResult> run(StatusProbeContext context) {
    return runner.run(definition, context, (snapshot, definition, context) {
      final canReadState =
          snapshot.bluetoothSupported && snapshot.bluetoothPermissionGranted;
      final enabled = canReadState && snapshot.bluetoothEnabled;
      final state = !snapshot.bluetoothSupported
          ? StatusProbeState.notObserved
          : !snapshot.bluetoothPermissionGranted
              ? StatusProbeState.watch
              : enabled
                  ? StatusProbeState.healthy
                  : StatusProbeState.watch;
      return probeResult(
        definition: definition,
        state: state,
        observedAt: snapshot.checkedAt,
        summary: !snapshot.bluetoothSupported
            ? 'Bluetooth support was not observed'
            : !snapshot.bluetoothPermissionGranted
                ? 'Bluetooth state cannot be read until Bluetooth permission is available'
                : enabled
                    ? 'Bluetooth is on'
                    : 'Bluetooth is not on',
        confidence: snapshot.bluetoothSupported ? 1 : 0.4,
        signals: [
          signal('Supported', snapshot.bluetoothSupported ? 'yes' : 'no'),
          signal(
            'Permission',
            snapshot.bluetoothPermissionGranted ? 'yes' : 'no',
          ),
          signal(
            'Enabled',
            canReadState
                ? (snapshot.bluetoothEnabled ? 'yes' : 'no')
                : 'unknown',
          ),
        ],
        sourceRefs: [sourceRef(definition.id.value, 'android.bluetooth')],
      );
    });
  }
}
