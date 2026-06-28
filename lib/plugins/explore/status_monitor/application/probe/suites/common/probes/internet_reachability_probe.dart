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

class InternetReachabilityProbe implements StatusProbeDriver {
  final CommonDeviceProbeRunner runner;

  InternetReachabilityProbe({CommonDeviceProbeRunner? runner})
      : runner = runner ?? const CommonDeviceProbeRunner();

  @override
  StatusProbeDefinition get definition => const StatusProbeDefinition(
        id: StatusProbeId('common.internet.validated'),
        suiteId: 'common',
        label: 'Internet reachability',
        kind: StatusProbeKind.common,
        category: StatusProbeCategory.network,
        runMode: StatusProbeRunMode.active,
        requiredForCorePath: true,
      );

  @override
  Future<StatusProbeResult> run(StatusProbeContext context) {
    return runner.run(definition, context, (snapshot, definition, context) {
      final reachable = snapshot.internetValidated;
      return probeResult(
        definition: definition,
        state: reachable ? StatusProbeState.healthy : StatusProbeState.watch,
        observedAt: snapshot.checkedAt,
        summary: reachable
            ? 'Internet access is validated'
            : 'Internet access is not validated',
        confidence: reachable ? 1 : 0.6,
        signals: [signal('Validated', reachable ? 'yes' : 'no')],
        evidence: [
          evidence('Internet', reachable ? 'yes' : 'no',
              observedAt: snapshot.checkedAt),
        ],
        sourceRefs: [
          sourceRef(definition.id.value, 'android.network.validated')
        ],
      );
    });
  }
}
