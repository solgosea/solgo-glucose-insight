import '../../../../../data/probe/platform/xdrip_probe_platform_source.dart';
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

class XdripBroadcastFreshnessProbe implements StatusProbeDriver {
  final XdripProbePlatformSource source;
  final StatusProbeFreshnessPolicy freshnessPolicy;

  XdripBroadcastFreshnessProbe({
    this.source = const XdripProbePlatformSource(),
    this.freshnessPolicy = const StatusProbeFreshnessPolicy(),
  });

  @override
  final definition = const StatusProbeDefinition(
    id: StatusProbeId('xdrip.broadcast.freshness'),
    suiteId: 'xdrip',
    label: 'xDrip+ broadcast freshness',
    kind: StatusProbeKind.xdrip,
    category: StatusProbeCategory.freshness,
    runMode: StatusProbeRunMode.derived,
    requiredForCorePath: true,
  );

  @override
  Future<StatusProbeResult> run(StatusProbeContext context) async {
    final snapshot = await source.latestBroadcast();
    final latest = snapshot.latestBroadcastAt;
    final state = freshnessPolicy.state(latest, context.now);
    final confidence = freshnessPolicy.confidence(latest, context.now);
    return probeResult(
      definition: definition,
      state: state,
      observedAt: latest ?? context.now,
      summary: latest == null
          ? 'No broadcast timestamp is available.'
          : 'Latest xDrip+ broadcast age is ${context.now.difference(latest).inMinutes}m.',
      confidence: confidence,
      signals: [
        signal(
          'Age',
          latest == null
              ? 'not observed'
              : '${context.now.difference(latest).inMinutes}m',
        ),
      ],
      sourceRefs: [
        sourceRef('android', 'xdrip.latestBroadcastAtMs'),
      ],
    );
  }
}
