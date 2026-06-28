import '../../../domain/xdrip/xdrip_broadcast_payload.dart';

class XdripBroadcastSnapshot {
  final bool receiverConfigured;
  final bool broadcastObserved;
  final DateTime? latestBroadcastAt;
  final XdripBroadcastPayload payload;
  final List<DateTime> timeline;

  const XdripBroadcastSnapshot({
    required this.receiverConfigured,
    required this.broadcastObserved,
    this.latestBroadcastAt,
    this.payload = const XdripBroadcastPayload(),
    this.timeline = const [],
  });
}
