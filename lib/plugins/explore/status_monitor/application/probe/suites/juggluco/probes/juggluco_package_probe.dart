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

class JugglucoPackageProbe implements StatusProbeDriver {
  final PackageProbePlatformSource source;

  JugglucoPackageProbe({
    this.source = const PackageProbePlatformSource(),
  });

  @override
  final definition = const StatusProbeDefinition(
    id: StatusProbeId('juggluco.package.visible'),
    suiteId: 'juggluco',
    label: 'Juggluco package visibility',
    kind: StatusProbeKind.juggluco,
    category: StatusProbeCategory.package,
    runMode: StatusProbeRunMode.active,
  );

  @override
  Future<StatusProbeResult> run(StatusProbeContext context) async {
    const packageName = 'tk.glucodata';
    final snapshot = await source.query(packageName);
    return packageProbeResult(
      definition: definition,
      snapshot: snapshot,
      observedAt: context.now,
      displayName: 'Juggluco',
      packageName: packageName,
    );
  }
}
