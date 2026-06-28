import '../../../domain/hub/facts/status_hub_fact_bundle.dart';
import '../../../domain/hub/status_hub_models.dart';
import 'status_hub_connection_metric_factory.dart';
import 'status_hub_metric_source_resolver.dart';

class CgmXdripMetricBuilder {
  final StatusHubConnectionMetricFactory factory;
  final StatusHubMetricSourceResolver sources;

  const CgmXdripMetricBuilder({
    this.factory = const StatusHubConnectionMetricFactory(),
    this.sources = const StatusHubMetricSourceResolver(),
  });

  List<StatusHubMetricFact> build(StatusHubFactBundle facts) {
    final cgm = facts.cgm.component;
    final xdrip = facts.xdrip.component;
    return [
      factory.age(
        id: 'latest_bg_age',
        label: 'Latest BG age',
        age: xdrip.age ?? cgm.age,
        source: sources.sourceFor(xdrip, 'xdrip_bg_broadcast').available
            ? sources.sourceFor(xdrip, 'xdrip_bg_broadcast')
            : sources.sourceFor(cgm, 'sensor_freshness'),
        meaning: 'How recent the local xDrip+ BG evidence is.',
      ),
      factory.unavailable(
        id: 'completeness_24h',
        label: '24h completeness',
        targetLabel: '>= 90%',
        meaning:
            'Requires a recent-window reading count fact; not inferred from freshness.',
      ),
      factory.unavailable(
        id: 'largest_gap',
        label: 'Largest gap',
        targetLabel: '<= 20m',
        meaning:
            'Requires continuity/gap analysis; not inferred from one broadcast.',
      ),
      factory.yesNo(
        id: 'bg_broadcast_observed',
        label: 'BG broadcast',
        observed: sources.evidenceObserved(xdrip, 'xdrip_bg_broadcast') ||
            sources.evidenceObserved(cgm, 'signal_continuity'),
        source: sources.sourceFor(xdrip, 'xdrip_bg_broadcast').available
            ? sources.sourceFor(xdrip, 'xdrip_bg_broadcast')
            : sources.sourceFor(cgm, 'signal_continuity'),
        meaning: 'Whether SolgoInsight has observed an xDrip+ BG broadcast.',
      ),
      factory.yesNo(
        id: 'receiver_package',
        label: 'Receiver package',
        observed: facts.xdrip.receiverPackage.isNotEmpty,
        source: const StatusHubSourceRef.derivedPolicy(
          'cgm_xdrip_metric_builder.receiver_package',
        ),
        valueOverride: facts.xdrip.receiverPackage,
        meaning: 'The package that should receive local BG broadcasts.',
      ),
    ];
  }
}
