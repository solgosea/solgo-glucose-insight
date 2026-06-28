import '../../../domain/hub/facts/status_hub_fact_bundle.dart';
import '../../../domain/hub/path/status_hub_connection_metric_requirement.dart';
import '../../../domain/hub/status_hub_models.dart';
import 'status_hub_connection_metric_factory.dart';
import 'status_hub_metric_source_resolver.dart';

class XdripAapsMetricBuilder {
  final StatusHubConnectionMetricFactory factory;
  final StatusHubMetricSourceResolver sources;

  const XdripAapsMetricBuilder({
    this.factory = const StatusHubConnectionMetricFactory(),
    this.sources = const StatusHubMetricSourceResolver(),
  });

  List<StatusHubMetricFact> build(StatusHubFactBundle facts) {
    final aaps = facts.aaps.component;
    final delay = _delay(facts.xdrip.component.age, aaps.age);
    final contextObserved = sources.evidenceObserved(aaps, 'aaps_loop_context');
    final devicestatusObserved = sources.evidenceObserved(
      aaps,
      'aaps_devicestatus',
    );
    return [
      factory.yesNo(
        id: 'bg_source',
        label: 'BG source',
        observed: facts.aaps.xdripBgSourceObserved,
        source: const StatusHubSourceRef.probeEvidence(
          probeId: 'aaps.bg_source.xdrip_evidence',
          path: 'xdripBgSource',
        ),
        valueOverride: facts.aaps.xdripBgSourceLabel,
        meaning:
            'Whether AAPS evidence indicates xDrip+ as the glucose source.',
      ),
      factory.age(
        id: 'loop_context_age',
        label: 'Loop context age',
        age: aaps.age,
        source: sources.sourceFor(aaps, 'aaps_loop_context'),
        meaning: 'How recent the observed AAPS loop context is.',
      ),
      factory.age(
        id: 'device_status_age',
        label: 'Device status age',
        age: devicestatusObserved ? aaps.age : null,
        source: sources.sourceFor(aaps, 'aaps_devicestatus'),
        requirement: StatusHubConnectionMetricRequirement.optional,
        meaning: 'Optional AAPS/device status evidence from Nightscout.',
      ),
      factory.ratio(
        id: 'context_fields',
        label: 'Context fields',
        available: [
          facts.aaps.xdripBgSourceObserved,
          contextObserved,
          devicestatusObserved,
        ].where((item) => item).length,
        expected: 3,
        source: const StatusHubSourceRef.derivedPolicy(
          'xdrip_aaps_metric_builder.context_fields',
        ),
        meaning:
            'How many downstream context facts are observable without judging therapy decisions.',
      ),
      factory.delay(
        id: 'downstream_alignment',
        label: 'Downstream alignment',
        delay: delay,
        source: const StatusHubSourceRef.derivedPolicy(
          'xdrip_aaps_metric_builder.downstream_alignment',
        ),
        meaning:
            'Whether AAPS context timing is close to local xDrip+ evidence.',
      ),
    ];
  }

  Duration? _delay(Duration? sourceAge, Duration? targetAge) {
    if (sourceAge == null || targetAge == null) return null;
    return targetAge - sourceAge;
  }
}
