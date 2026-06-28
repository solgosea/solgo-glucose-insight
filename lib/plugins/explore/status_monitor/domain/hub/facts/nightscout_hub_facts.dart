import 'status_hub_component_facts.dart';

class NightscoutHubFacts {
  final StatusHubComponentFacts component;
  final String latestServerReadingLabel;
  final int? medianResponseMs;
  final int timeoutCount;

  const NightscoutHubFacts({
    required this.component,
    required this.latestServerReadingLabel,
    this.medianResponseMs,
    required this.timeoutCount,
  });
}
