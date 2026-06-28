import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'aaps_evidence_bridge.dart';
import 'aaps_evidence_snapshot.dart';

class MethodChannelAapsEvidenceBridge implements AapsEvidenceBridge {
  final MethodChannel channel;
  final TargetPlatform? platform;

  const MethodChannelAapsEvidenceBridge({
    this.channel = const MethodChannel('com.metaguru.smartxdrip/aaps_evidence'),
    this.platform,
  });

  TargetPlatform get _platform => platform ?? defaultTargetPlatform;

  @override
  bool get isSupported => _platform == TargetPlatform.android;

  @override
  Future<AapsEvidenceSnapshot> latest() async {
    if (!isSupported) {
      return const AapsEvidenceSnapshot(
        receiverConfigured: false,
        evidenceObserved: false,
      );
    }
    final result = await channel.invokeMapMethod<String, Object?>('latest');
    return _snapshot(result ?? const {});
  }

  AapsEvidenceSnapshot _snapshot(Map<String, Object?> data) {
    return AapsEvidenceSnapshot(
      receiverConfigured: data['receiverConfigured'] == true,
      evidenceObserved: data['evidenceObserved'] == true,
      latestEvidenceAt: _date(data['latestEvidenceAtMs']),
      bgSource: data['bgSource']?.toString(),
      devicestatusObserved: data['devicestatusObserved'] == true,
      loopContextObserved: data['loopContextObserved'] == true,
      loopState: data['loopState']?.toString(),
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
