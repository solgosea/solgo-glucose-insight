import '../../status_level.dart';
import 'status_hub_component_facts.dart';

class XdripHubFacts {
  final StatusHubComponentFacts component;
  final bool localBroadcastObserved;
  final StatusLevel broadcastLevel;
  final String broadcastStateLabel;
  final String broadcastLatestLabel;
  final String receiverPackage;
  final String modeLabel;

  const XdripHubFacts({
    required this.component,
    required this.localBroadcastObserved,
    required this.broadcastLevel,
    required this.broadcastStateLabel,
    required this.broadcastLatestLabel,
    required this.receiverPackage,
    required this.modeLabel,
  });
}
