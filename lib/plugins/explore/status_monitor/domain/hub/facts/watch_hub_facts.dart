import 'status_hub_component_facts.dart';

class WatchHubFacts {
  final StatusHubComponentFacts component;
  final bool bridgePackageObserved;
  final bool webServiceReachable;
  final bool entriesObserved;
  final bool displayObserved;
  final String latestDisplayLabel;

  const WatchHubFacts({
    required this.component,
    required this.bridgePackageObserved,
    required this.webServiceReachable,
    required this.entriesObserved,
    required this.displayObserved,
    required this.latestDisplayLabel,
  });
}
