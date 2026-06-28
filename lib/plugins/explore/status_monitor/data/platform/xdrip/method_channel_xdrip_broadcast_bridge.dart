import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../../domain/xdrip/xdrip_broadcast_payload.dart';
import 'xdrip_broadcast_bridge.dart';
import 'xdrip_broadcast_snapshot.dart';

class MethodChannelXdripBroadcastBridge implements XdripBroadcastBridge {
  final MethodChannel channel;
  final TargetPlatform? platform;

  const MethodChannelXdripBroadcastBridge({
    this.channel =
        const MethodChannel('com.metaguru.smartxdrip/xdrip_broadcast'),
    this.platform,
  });

  TargetPlatform get _platform => platform ?? defaultTargetPlatform;

  @override
  bool get isSupported => _platform == TargetPlatform.android;

  @override
  Future<XdripBroadcastSnapshot> latest() async {
    if (!isSupported) {
      return const XdripBroadcastSnapshot(
        receiverConfigured: false,
        broadcastObserved: false,
      );
    }
    final result = await channel.invokeMapMethod<String, Object?>('latest');
    return _snapshot(result ?? const {});
  }

  XdripBroadcastSnapshot _snapshot(Map<String, Object?> data) {
    return XdripBroadcastSnapshot(
      receiverConfigured: data['receiverConfigured'] == true,
      broadcastObserved: data['broadcastObserved'] == true,
      latestBroadcastAt: _date(data['latestBroadcastAtMs']),
      payload: XdripBroadcastPayload(
        glucose: (data['latestGlucose'] as num?)?.toDouble(),
        unit: data['unit']?.toString(),
        slopeName: data['slopeName']?.toString(),
        slope: (data['slope'] as num?)?.toDouble(),
        sourceAction: data['sourceAction']?.toString(),
      ),
      timeline: _timeline(data['timeline']),
    );
  }

  DateTime? _date(Object? value) {
    final ms = (value as num?)?.toInt();
    if (ms == null || ms <= 0) return null;
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }

  List<DateTime> _timeline(Object? value) {
    if (value is! List) return const [];
    return value
        .map((item) => item is Map ? _date(item['atMs']) : null)
        .whereType<DateTime>()
        .toList(growable: false);
  }
}
