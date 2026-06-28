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

class NetworkConnectivityProbe implements StatusProbeDriver {
  final CommonDeviceProbeRunner runner;

  NetworkConnectivityProbe({CommonDeviceProbeRunner? runner})
      : runner = runner ?? const CommonDeviceProbeRunner();

  @override
  StatusProbeDefinition get definition => const StatusProbeDefinition(
        id: StatusProbeId('common.network.connectivity'),
        suiteId: 'common',
        label: 'Network connectivity',
        kind: StatusProbeKind.common,
        category: StatusProbeCategory.network,
        runMode: StatusProbeRunMode.active,
        requiredForCorePath: true,
      );

  @override
  Future<StatusProbeResult> run(StatusProbeContext context) {
    return runner.run(definition, context, (snapshot, definition, context) {
      final connected = snapshot.networkConnected;
      return probeResult(
        definition: definition,
        state: connected ? StatusProbeState.healthy : StatusProbeState.issue,
        observedAt: snapshot.checkedAt,
        summary: connected
            ? 'Phone has a network connection'
            : 'Phone has no network connection',
        confidence: connected ? 1 : 0.95,
        signals: [signal('Network', snapshot.networkType)],
        evidence: [
          evidence('Connected', connected ? 'yes' : 'no',
              observedAt: snapshot.checkedAt),
        ],
        sourceRefs: [sourceRef(definition.id.value, 'android.network')],
      );
    });
  }
}
