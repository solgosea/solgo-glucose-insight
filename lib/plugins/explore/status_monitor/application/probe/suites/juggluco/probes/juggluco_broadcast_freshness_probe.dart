import '../../../../../data/probe/platform/juggluco_probe_platform_source.dart';
import '../../../../../domain/probe/status_probe_category.dart';
import '../../../../../domain/probe/status_probe_context.dart';
import '../../../../../domain/probe/status_probe_definition.dart';
import '../../../../../domain/probe/status_probe_id.dart';
import '../../../../../domain/probe/status_probe_kind.dart';
import '../../../../../domain/probe/status_probe_result.dart';
import '../../../../../domain/probe/status_probe_run_mode.dart';
import '../../../contracts/status_probe_driver.dart';
import '../../../policies/status_probe_freshness_policy.dart';
import '../../status_probe_result_helpers.dart';

class JugglucoBroadcastFreshnessProbe implements StatusProbeDriver {
  final JugglucoProbePlatformSource source;
  final StatusProbeFreshnessPolicy freshnessPolicy;

  JugglucoBroadcastFreshnessProbe({
    this.source = const JugglucoProbePlatformSource(),
    this.freshnessPolicy = const StatusProbeFreshnessPolicy(),
  });

  @override
  final definition = const StatusProbeDefinition(
    id: StatusProbeId('juggluco.broadcast.freshness'),
    suiteId: 'juggluco',
    label: 'Juggluco broadcast freshness',
    kind: StatusProbeKind.juggluco,
    category: StatusProbeCategory.freshness,
    runMode: StatusProbeRunMode.derived,
    requiredForCorePath: true,
  );

  @override
  Future<StatusProbeResult> run(StatusProbeContext context) async {
    final snapshot = await source.latestBroadcast();
    final latest = snapshot.latestBroadcastAt;
    final state = freshnessPolicy.state(latest, context.now);
    return probeResult(
      definition: definition,
      state: state,
      observedAt: latest ?? context.now,
      summary: latest == null
          ? 'No Juggluco broadcast timestamp is available.'
          : 'Latest Juggluco broadcast age is ${context.now.difference(latest).inMinutes}m.',
      confidence: freshnessPolicy.confidence(latest, context.now),
      signals: [
        signal(
          'Age',
          latest == null
              ? 'not observed'
              : '${context.now.difference(latest).inMinutes}m',
        ),
      ],
      sourceRefs: [sourceRef('android', 'juggluco.latestBroadcastAtMs')],
    );
  }
}
