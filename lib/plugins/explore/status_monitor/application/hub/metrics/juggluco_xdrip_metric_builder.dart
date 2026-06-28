import '../../../domain/hub/facts/status_hub_fact_bundle.dart';
import '../../../domain/hub/path/status_hub_connection_metric_requirement.dart';
import '../../../domain/hub/status_hub_models.dart';
import 'status_hub_connection_metric_factory.dart';
import 'status_hub_metric_normalizer.dart';
import 'status_hub_metric_source_resolver.dart';

class JugglucoXdripMetricBuilder {
  final StatusHubConnectionMetricFactory factory;
  final StatusHubMetricNormalizer normalizer;
  final StatusHubMetricSourceResolver sources;

  const JugglucoXdripMetricBuilder({
    this.factory = const StatusHubConnectionMetricFactory(),
    this.normalizer = const StatusHubMetricNormalizer(),
    this.sources = const StatusHubMetricSourceResolver(),
  });

  List<StatusHubMetricFact> build(StatusHubFactBundle facts) {
    final juggluco = facts.juggluco.component;
    final compatible = facts.juggluco.xdripCompatiblePathObserved;
    final directObserved = sources.evidenceObserved(
      juggluco,
      'juggluco_glucodata',
    );
    final compatibleObserved = sources.evidenceObserved(
      juggluco,
      'juggluco_xdrip_handoff',
    );
    final broadcastValue = sources.valueFor(
      juggluco,
      'juggluco_broadcast_freshness',
    );
    final broadcastObserved = sources.evidenceObserved(
      juggluco,
      'juggluco_broadcast_freshness',
    );
    return [
      broadcastObserved
          ? factory.age(
              id: 'juggluco_broadcast_age',
              label: 'Juggluco broadcast age',
              age: juggluco.age,
              source: sources.sourceFor(
                juggluco,
                'juggluco_broadcast_freshness',
              ),
              meaning: 'How recent the latest Juggluco broadcast evidence is.',
            )
          : factory.metric(
              id: 'juggluco_broadcast_age',
              label: 'Juggluco broadcast age',
              valueLabel: broadcastValue,
              numericValue: null,
              unit: null,
              targetLabel: '<= 6m',
              quantification: normalizer.unknown(),
              source: sources.sourceFor(
                juggluco,
                'juggluco_broadcast_freshness',
              ),
              requirement: StatusHubConnectionMetricRequirement.required,
              meaning: 'How recent the latest Juggluco broadcast evidence is.',
            ),
      factory.yesNo(
        id: 'xdrip_compatible_broadcast',
        label: 'xDrip-compatible broadcast',
        observed: compatibleObserved,
        partial: compatible && !compatibleObserved,
        source: sources.sourceFor(juggluco, 'juggluco_xdrip_handoff'),
        meaning:
            'Whether the Juggluco broadcast is visible in the xDrip-compatible path.',
      ),
      factory.metric(
        id: 'format_compatibility',
        label: 'Format compatibility',
        valueLabel: facts.juggluco.observedPathLabel,
        numericValue: compatible
            ? 1
            : directObserved
                ? .6
                : 0,
        unit: 'score',
        targetLabel: 'xDrip-compatible',
        quantification: normalizer.boolean(compatible, partial: directObserved),
        source: const StatusHubSourceRef.probeEvidence(
          probeId: 'juggluco.broadcast.xdrip_compatible',
          path: 'observedPathLabel',
        ),
        requirement: facts.juggluco.hasXdripCompatiblePathEvidence
            ? StatusHubConnectionMetricRequirement.required
            : StatusHubConnectionMetricRequirement.unavailable,
        meaning:
            'xDrip-compatible format matters because this path feeds xDrip+.',
      ),
      factory.yesNo(
        id: 'receiver_target',
        label: 'Receiver target',
        observed: facts.juggluco.receiverLabel.isNotEmpty,
        source: const StatusHubSourceRef.probeEvidence(
          probeId: 'juggluco.broadcast.xdrip_compatible',
          path: 'receiverPackage',
        ),
        valueOverride: facts.juggluco.receiverLabel,
        meaning: 'The Android package expected to receive the broadcast.',
      ),
      factory.delay(
        id: 'handoff_alignment',
        label: 'Handoff alignment',
        delay: compatibleObserved ? facts.juggluco.component.age : null,
        source: sources.sourceFor(juggluco, 'juggluco_xdrip_handoff'),
        meaning: 'Whether the compatible handoff is recent enough to trust.',
      ),
    ];
  }
}
