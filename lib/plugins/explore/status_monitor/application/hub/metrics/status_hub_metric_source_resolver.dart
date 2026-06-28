import '../../../domain/hub/facts/status_hub_component_facts.dart';
import '../../../domain/hub/status_hub_models.dart';

class StatusHubMetricSourceResolver {
  const StatusHubMetricSourceResolver();

  StatusHubSourceRef sourceFor(
    StatusHubComponentFacts component,
    String evidenceId,
  ) {
    for (final evidence in component.evidence) {
      if (evidence.id == evidenceId) return evidence.source;
    }
    return const StatusHubSourceRef.unavailable();
  }

  bool evidenceObserved(StatusHubComponentFacts component, String evidenceId) {
    for (final evidence in component.evidence) {
      if (evidence.id != evidenceId) continue;
      if (!evidence.source.available) return false;
      final value = evidence.valueLabel.trim().toLowerCase();
      return value.isNotEmpty &&
          !value.contains('unknown') &&
          !value.contains('waiting') &&
          !value.contains('not seen') &&
          !value.contains('no broadcast') &&
          value != '--';
    }
    return false;
  }

  String valueFor(
    StatusHubComponentFacts component,
    String evidenceId, {
    String fallback = 'Unknown',
  }) {
    for (final evidence in component.evidence) {
      if (evidence.id == evidenceId) return evidence.valueLabel;
    }
    return fallback;
  }
}
