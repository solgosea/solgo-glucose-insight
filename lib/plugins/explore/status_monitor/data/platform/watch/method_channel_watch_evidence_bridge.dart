import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'watch_evidence_bridge.dart';
import 'watch_evidence_snapshot.dart';

class MethodChannelWatchEvidenceBridge implements WatchEvidenceBridge {
  final MethodChannel channel;
  final TargetPlatform? platform;

  const MethodChannelWatchEvidenceBridge({
    this.channel =
        const MethodChannel('com.metaguru.smartxdrip/watch_evidence'),
    this.platform,
  });

  TargetPlatform get _platform => platform ?? defaultTargetPlatform;

  @override
  bool get isSupported => _platform == TargetPlatform.android;

  @override
  Future<WatchEvidenceSnapshot> latest() async {
    if (!isSupported) {
      return const WatchEvidenceSnapshot(
        receiverConfigured: false,
        evidenceObserved: false,
      );
    }
    final result = await channel.invokeMapMethod<String, Object?>('latest');
    return _snapshot(result ?? const {});
  }

  WatchEvidenceSnapshot _snapshot(Map<String, Object?> data) {
    return WatchEvidenceSnapshot(
      receiverConfigured: data['receiverConfigured'] == true,
      evidenceObserved: data['evidenceObserved'] == true,
      latestEvidenceAt: _date(data['latestEvidenceAtMs']),
      bridgeName: data['bridgeName']?.toString(),
      displayObserved: data['displayObserved'] == true,
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
