import '../../../../../data/probe/platform/package_probe_platform_source.dart';
import '../../../../../domain/probe/status_probe_category.dart';
import '../../../../../domain/probe/status_probe_context.dart';
import '../../../../../domain/probe/status_probe_definition.dart';
import '../../../../../domain/probe/status_probe_id.dart';
import '../../../../../domain/probe/status_probe_kind.dart';
import '../../../../../domain/probe/status_probe_result.dart';
import '../../../../../domain/probe/status_probe_run_mode.dart';
import '../../../contracts/status_probe_driver.dart';
import '../../package_probe_result_builder.dart';

class WatchBridgePackageProbe implements StatusProbeDriver {
  final PackageProbePlatformSource source;

  WatchBridgePackageProbe({
    this.source = const PackageProbePlatformSource(),
  });

  @override
  final definition = const StatusProbeDefinition(
    id: StatusProbeId('watch.bridge.package'),
    suiteId: 'watch',
    label: 'Watch bridge package',
    kind: StatusProbeKind.watch,
    category: StatusProbeCategory.package,
    runMode: StatusProbeRunMode.active,
  );

  @override
  Future<StatusProbeResult> run(StatusProbeContext context) async {
    const packageNames = [
      'com.thatguysservice.huami_xdrip',
      'com.thatguysservice.watchdrip',
      'com.thatguysservice.watchdripplus',
    ];
    final snapshots = await Future.wait(packageNames.map(source.query));
    return packageCandidatesProbeResult(
      definition: definition,
      snapshots: snapshots,
      observedAt: context.now,
      displayName: 'Watch bridge',
      packageNames: packageNames,
    );
  }
}
