import 'status_hub_component_facts.dart';

class CgmHubFacts {
  final StatusHubComponentFacts component;
  final String latestReadingAgeLabel;
  final String sourceModeLabel;

  const CgmHubFacts({
    required this.component,
    required this.latestReadingAgeLabel,
    required this.sourceModeLabel,
  });
}
