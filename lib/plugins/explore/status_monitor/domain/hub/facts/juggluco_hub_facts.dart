import 'status_hub_component_facts.dart';

class JugglucoHubFacts {
  final StatusHubComponentFacts component;
  final bool xdripCompatiblePathObserved;
  final bool hasXdripCompatiblePathEvidence;
  final String receiverLabel;
  final String latestLabel;
  final String xdripAgeLabel;
  final String nightscoutAgeLabel;
  final String observedPathLabel;

  const JugglucoHubFacts({
    required this.component,
    required this.xdripCompatiblePathObserved,
    required this.hasXdripCompatiblePathEvidence,
    required this.receiverLabel,
    required this.latestLabel,
    required this.xdripAgeLabel,
    required this.nightscoutAgeLabel,
    required this.observedPathLabel,
  });
}
