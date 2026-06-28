import 'xdrip_broadcast_payload.dart';
import 'xdrip_broadcast_state.dart';

class XdripBroadcastEvidence {
  final bool receiverConfigured;
  final bool broadcastObserved;
  final DateTime? latestBroadcastAt;
  final XdripBroadcastPayload payload;
  final List<DateTime> timeline;
  final DateTime generatedAt;

  const XdripBroadcastEvidence({
    required this.receiverConfigured,
    required this.broadcastObserved,
    this.latestBroadcastAt,
    this.payload = const XdripBroadcastPayload(),
    this.timeline = const [],
    required this.generatedAt,
  });

  const XdripBroadcastEvidence.none({required this.generatedAt})
      : receiverConfigured = false,
        broadcastObserved = false,
        latestBroadcastAt = null,
        payload = const XdripBroadcastPayload(),
        timeline = const [];

  bool get hasValidPayload => broadcastObserved && payload.valid;

  Duration? latestAge(DateTime now) {
    final latest = latestBroadcastAt;
    if (latest == null) return null;
    return now.difference(latest).abs();
  }

  XdripBroadcastState state(DateTime now) {
    if (!receiverConfigured) return XdripBroadcastState.unknown;
    if (!broadcastObserved || latestBroadcastAt == null) {
      return XdripBroadcastState.missing;
    }
    if (!payload.valid) return XdripBroadcastState.invalid;
    final age = latestAge(now);
    if (age == null) return XdripBroadcastState.unknown;
    if (age.inMinutes <= 10) return XdripBroadcastState.fresh;
    return XdripBroadcastState.stale;
  }

  String latestAgeLabel(DateTime now) {
    final age = latestAge(now);
    if (age == null) return 'Not observed';
    if (age.inSeconds < 45) return '${age.inSeconds}s ago';
    if (age.inMinutes < 60) return '${age.inMinutes}m ago';
    if (age.inHours < 24) return '${age.inHours}h ago';
    return '${age.inDays}d ago';
  }
}
