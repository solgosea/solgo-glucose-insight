import '../../../../domain/component_evidence/status_component_evidence_state.dart';
import '../../../../domain/status_metric.dart';
import '../../../../domain/status_metric_source.dart';
import '../facts/watch_evidence_bundle.dart';

class WatchMetricBuilder {
  const WatchMetricBuilder();

  List<StatusMetric> build(WatchEvidenceBundle bundle) {
    final evidenceById = {
      for (final fact in bundle.evidenceFacts) fact.id: fact
    };
    return bundle.pathFacts
        .map(
          (fact) => StatusMetric(
            id: fact.id,
            label: fact.title,
            valueLabel: fact.body,
            level: fact.level,
            source: StatusMetricSource.localProbe,
            observedAt: fact.observedAt,
            available: evidenceById[fact.id]?.state.available ?? false,
            note: fact.sourceLabel,
          ),
        )
        .toList(growable: false);
  }
}
