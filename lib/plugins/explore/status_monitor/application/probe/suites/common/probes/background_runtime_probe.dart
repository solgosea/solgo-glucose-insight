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

class BackgroundRuntimeProbe implements StatusProbeDriver {
  final CommonDeviceProbeRunner runner;

  BackgroundRuntimeProbe({CommonDeviceProbeRunner? runner})
      : runner = runner ?? const CommonDeviceProbeRunner();

  @override
  StatusProbeDefinition get definition => const StatusProbeDefinition(
        id: StatusProbeId('common.runtime.background'),
        suiteId: 'common',
        label: 'Background runtime',
        kind: StatusProbeKind.common,
        category: StatusProbeCategory.runtime,
        runMode: StatusProbeRunMode.active,
      );

  @override
  Future<StatusProbeResult> run(StatusProbeContext context) {
    return runner.run(definition, context, (snapshot, definition, context) {
      final good = snapshot.notificationPermissionGranted &&
          !snapshot.powerSaveMode &&
          snapshot.networkConnected;
      return probeResult(
        definition: definition,
        state: good ? StatusProbeState.healthy : StatusProbeState.watch,
        observedAt: snapshot.checkedAt,
        summary: good
            ? 'Runtime conditions look usable'
            : 'Runtime conditions may limit checks',
        confidence: good ? 0.9 : 0.55,
        signals: [
          signal('Network', snapshot.networkConnected ? 'yes' : 'no'),
          signal('Notifications',
              snapshot.notificationPermissionGranted ? 'yes' : 'no'),
          signal('Power save', snapshot.powerSaveMode ? 'yes' : 'no'),
        ],
        sourceRefs: [sourceRef(definition.id.value, 'android.runtime')],
      );
    });
  }
}
