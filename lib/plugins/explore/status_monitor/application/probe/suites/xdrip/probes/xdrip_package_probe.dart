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

class XdripPackageProbe implements StatusProbeDriver {
  final PackageProbePlatformSource source;

  XdripPackageProbe({
    this.source = const PackageProbePlatformSource(),
  });

  @override
  final definition = const StatusProbeDefinition(
    id: StatusProbeId('xdrip.package.visible'),
    suiteId: 'xdrip',
    label: 'xDrip+ package visibility',
    kind: StatusProbeKind.xdrip,
    category: StatusProbeCategory.package,
    runMode: StatusProbeRunMode.active,
  );

  @override
  Future<StatusProbeResult> run(StatusProbeContext context) async {
    const packageNames = [
      'com.eveningoutpost.dexdrip',
      'jamorham.xdrip.plus',
      'jamorham.xdrip.plus.variant1',
      'jamorham.xdrip.plus.variant2',
      'jamorham.xdrip.plus.variant3',
      'jamorham.xdrip.plus.variant4',
    ];
    final snapshots = await Future.wait(packageNames.map(source.query));
    return packageCandidatesProbeResult(
      definition: definition,
      snapshots: snapshots,
      observedAt: context.now,
      displayName: 'xDrip+',
      packageNames: packageNames,
    );
  }
}
