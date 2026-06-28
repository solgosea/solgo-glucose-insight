import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../../domain/juggluco/juggluco_broadcast_format.dart';
import '../../../domain/juggluco/juggluco_broadcast_path.dart';
import '../../../domain/juggluco/juggluco_broadcast_path_snapshot.dart';
import '../../../domain/juggluco/juggluco_freshness_bucket.dart';
import '../../../domain/juggluco/juggluco_path_state.dart';
import 'juggluco_broadcast_bridge.dart';
import 'juggluco_broadcast_snapshot.dart';

class MethodChannelJugglucoBroadcastBridge implements JugglucoBroadcastBridge {
  final MethodChannel channel;
  final TargetPlatform? platform;

  const MethodChannelJugglucoBroadcastBridge({
    this.channel =
        const MethodChannel('com.metaguru.smartxdrip/juggluco_broadcast'),
    this.platform,
  });

  TargetPlatform get _platform => platform ?? defaultTargetPlatform;

  @override
  bool get isSupported => _platform == TargetPlatform.android;

  @override
  Future<JugglucoBroadcastSnapshot> latest() async {
    if (!isSupported) {
      return const JugglucoBroadcastSnapshot(
        receiverConfigured: false,
        broadcastObserved: false,
      );
    }
    final result = await channel.invokeMapMethod<String, Object?>('latest');
    return _snapshot(result ?? const {});
  }

  JugglucoBroadcastSnapshot _snapshot(Map<String, Object?> data) {
    return JugglucoBroadcastSnapshot(
      receiverConfigured: data['receiverConfigured'] == true,
      broadcastObserved: data['broadcastObserved'] == true,
      latestBroadcastAt: _date(data['latestBroadcastAtMs']),
      latestGlucose: (data['latestGlucose'] as num?)?.toDouble(),
      unit: data['unit']?.toString(),
      broadcastFormat:
          JugglucoBroadcastFormat.fromName(data['broadcastFormat']?.toString()),
      latestPath:
          JugglucoBroadcastPath.fromName(data['latestPath']?.toString()),
      latestByPath: _latestByPath(data['latestByPath']),
      sanitizedMessage: data['sanitizedMessage']?.toString(),
      timeline: _timeline(data['timeline']),
    );
  }

  DateTime? _date(Object? value) {
    final ms = (value as num?)?.toInt();
    if (ms == null || ms <= 0) return null;
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }

  List<JugglucoFreshnessBucket> _timeline(Object? value) {
    if (value is! List) return const [];
    return value.whereType<Map>().map((item) {
      final at = _date(item['atMs']) ?? DateTime.now();
      final state = _state(item['state']?.toString());
      final path = JugglucoBroadcastPath.fromName(item['path']?.toString());
      return JugglucoFreshnessBucket(at: at, state: state, path: path);
    }).toList(growable: false);
  }

  List<JugglucoBroadcastPathSnapshot> _latestByPath(Object? value) {
    if (value is! List) return const [];
    return value.whereType<Map>().map((item) {
      return JugglucoBroadcastPathSnapshot(
        path: JugglucoBroadcastPath.fromName(item['path']?.toString()),
        at: _date(item['atMs']),
        glucose: (item['glucose'] as num?)?.toDouble(),
        unit: item['unit']?.toString(),
        format: JugglucoBroadcastFormat.fromName(item['format']?.toString()),
        message: item['message']?.toString(),
      );
    }).toList(growable: false);
  }

  JugglucoPathState _state(String? value) {
    return JugglucoPathState.values.firstWhere(
      (state) => state.name == value,
      orElse: () => JugglucoPathState.unknown,
    );
  }
}
