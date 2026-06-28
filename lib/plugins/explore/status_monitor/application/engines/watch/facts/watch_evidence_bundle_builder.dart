import '../../../../domain/component_evidence/status_component_evidence_fact.dart';
import '../../../../domain/component_evidence/status_component_evidence_snapshot.dart';
import '../../../../domain/status_level.dart';
import '../../../../domain/trace/status_evidence_trace.dart';
import '../mapping/watch_evidence_state_mapper.dart';
import 'watch_evidence_bundle.dart';
import 'watch_path_fact.dart';
import 'watch_signal_fact.dart';

class WatchEvidenceBundleBuilder {
  final WatchEvidenceStateMapper stateMapper;

  const WatchEvidenceBundleBuilder({
    this.stateMapper = const WatchEvidenceStateMapper(),
  });

  WatchEvidenceBundle build(StatusComponentEvidenceSnapshot? snapshot) {
    final evidenceFacts =
        snapshot?.facts ?? const <StatusComponentEvidenceFact>[];
    final pathFacts = _pathFacts(evidenceFacts);
    return WatchEvidenceBundle(
      snapshot: snapshot,
      evidenceFacts: evidenceFacts,
      pathFacts: pathFacts,
      signalFacts: pathFacts
          .map(
            (fact) => WatchSignalFact(
              id: fact.id,
              label: fact.title,
              valueLabel: fact.valueLabel,
              level: fact.level,
              observedAt: fact.observedAt,
              confidence: fact.confidence,
              sourceLabel: fact.sourceLabel,
              trace: fact.trace,
            ),
          )
          .toList(growable: false),
    );
  }

  List<WatchPathFact> _pathFacts(
    List<StatusComponentEvidenceFact> facts,
  ) {
    final byId = {for (final fact in facts) fact.id: fact};
    return [
      _pathFact(
        byId['watch.bridge.package'],
        id: 'watch.bridge.package',
        title: 'Watch bridge package',
        emptyBody:
            'No WatchDrip or compatible watch bridge package was observed.',
      ),
      _pathFact(
        byId['watch.xdrip_web_service.reachable'],
        id: 'watch.xdrip_web_service.reachable',
        title: 'xDrip+ Web Service reachable',
        emptyBody:
            'xDrip+ Web Service evidence is not available for this watch path.',
      ),
      _pathFact(
        byId['watch.xdrip_web_service.entries'],
        id: 'watch.xdrip_web_service.entries',
        title: 'xDrip+ entries visible',
        emptyBody:
            'No xDrip+ Web Service entries evidence was available for this run.',
      ),
      _pathFact(
        byId['watch.display.evidence'],
        id: 'watch.display.evidence',
        title: 'Fresh watch display evidence',
        emptyBody: 'No recent watch-side display evidence was observed.',
      ),
    ];
  }

  WatchPathFact _pathFact(
    StatusComponentEvidenceFact? fact, {
    required String id,
    required String title,
    required String emptyBody,
  }) {
    if (fact == null) {
      return WatchPathFact(
        id: id,
        title: title,
        body: emptyBody,
        valueLabel: 'Unknown',
        level: StatusLevel.unknown,
        observedAt: null,
        confidence: 0,
        sourceLabel: 'probe unavailable',
        trace: StatusEvidenceTrace.empty,
      );
    }
    return WatchPathFact(
      id: id,
      title: fact.label.isEmpty ? title : fact.label,
      body: fact.valueLabel,
      valueLabel: stateMapper.displayValue(fact.state),
      level: stateMapper.level(fact.state),
      observedAt: fact.observedAt,
      confidence: fact.confidence,
      sourceLabel: stateMapper.sourceLabel(fact.source),
      trace: fact.trace,
    );
  }
}
