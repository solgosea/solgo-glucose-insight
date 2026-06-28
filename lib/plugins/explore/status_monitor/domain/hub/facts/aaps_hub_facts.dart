import '../../status_level.dart';
import 'status_hub_component_facts.dart';

class AapsHubFacts {
  final StatusHubComponentFacts component;
  final bool xdripBgSourceObserved;
  final bool hasXdripBgSourceEvidence;
  final StatusLevel xdripBgSourceLevel;
  final String xdripBgSourceLabel;
  final String latestContextLabel;

  const AapsHubFacts({
    required this.component,
    required this.xdripBgSourceObserved,
    required this.hasXdripBgSourceEvidence,
    required this.xdripBgSourceLevel,
    required this.xdripBgSourceLabel,
    required this.latestContextLabel,
  });
}
