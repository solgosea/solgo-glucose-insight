import '../status_level.dart';
import 'xdrip_broadcast_state.dart';

class XdripBroadcastReadiness {
  final XdripBroadcastState state;
  final StatusLevel level;
  final String stateLabel;
  final String latestLabel;
  final String payloadLabel;
  final String receiverPackage;
  final String guidance;

  const XdripBroadcastReadiness({
    required this.state,
    required this.level,
    required this.stateLabel,
    required this.latestLabel,
    required this.payloadLabel,
    required this.receiverPackage,
    required this.guidance,
  });

  Map<String, Object?> toJson() => {
        'state': state.name,
        'level': level.name,
        'stateLabel': stateLabel,
        'latestLabel': latestLabel,
        'payloadLabel': payloadLabel,
        'receiverPackage': receiverPackage,
        'guidance': guidance,
      };
}
