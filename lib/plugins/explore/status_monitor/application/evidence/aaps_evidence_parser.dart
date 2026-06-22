import '../../domain/aaps/aaps_device_status_sample.dart';
import '../../domain/aaps/aaps_iob_cob_context.dart';
import '../../domain/aaps/aaps_loop_context.dart';
import '../../domain/aaps/aaps_profile_context.dart';
import '../../domain/aaps/aaps_pump_context.dart';
import '../../domain/evidence/aaps_evidence.dart';
import '../../domain/evidence/nightscout_evidence.dart';

class AapsEvidenceParser {
  const AapsEvidenceParser();

  AapsEvidence parse({
    required NightscoutEvidence nightscout,
    required DateTime now,
  }) {
    final samples = nightscout.deviceStatus
        .map(_sample)
        .whereType<AapsDeviceStatusSample>()
        .toList(growable: false);
    final usable = samples
        .where(
          (sample) =>
              sample.hasLoopContext ||
              sample.hasPumpContext ||
              sample.hasIobContext ||
              sample.hasCobContext ||
              sample.hasProfileContext,
        )
        .toList(growable: false);
    usable.sort((a, b) {
      final left = a.observedAt;
      final right = b.observedAt;
      if (left == null && right == null) return 0;
      if (left == null) return 1;
      if (right == null) return -1;
      return right.compareTo(left);
    });
    final latest = usable.isEmpty ? null : usable.first;
    return AapsEvidence(
      configured: nightscout.configured,
      nightscoutReachable: nightscout.apiAvailable,
      deviceStatusSamples: samples,
      generatedAt: nightscout.generatedAt ?? now,
      latestLoop: latest == null ? null : _loopContext(latest),
      latestPump: latest == null ? null : _pumpContext(latest),
      latestIobCob: latest == null ? null : _iobCobContext(latest),
      latestProfile: latest == null ? null : _profileContext(latest),
      sanitizedFailureLabel: nightscout.failureLabel,
    );
  }

  AapsDeviceStatusSample? _sample(Map<String, dynamic> row) {
    final openaps = _map(row['openaps']);
    final pump = _map(row['pump']);
    final iob = _map(row['iob']) ?? _map(openaps?['iob']);
    final cob = row['cob'] ?? openaps?['cob'];
    final profile = row['profile'] ??
        row['profileName'] ??
        row['profileJson'] ??
        row['tempTarget'] ??
        openaps?['profile'] ??
        openaps?['tempTarget'];
    final observedAt = _time(row['created_at']) ??
        _time(row['createdAt']) ??
        _time(row['mills']) ??
        _time(row['date']) ??
        _time(openaps?['timestamp']) ??
        _time(openaps?['mills']);
    return AapsDeviceStatusSample(
      observedAt: observedAt,
      hasLoopContext: openaps != null && openaps.isNotEmpty,
      hasPumpContext: pump != null && pump.isNotEmpty,
      hasIobContext: iob != null && iob.isNotEmpty,
      hasCobContext: cob != null,
      hasProfileContext: profile != null,
      loop: openaps ?? const {},
      pump: pump ?? const {},
    );
  }

  AapsLoopContext _loopContext(AapsDeviceStatusSample sample) {
    final partial = sample.loop.length < 2;
    return AapsLoopContext(
      observedAt: sample.observedAt,
      visible: sample.hasLoopContext,
      partial: partial,
      label: sample.hasLoopContext
          ? partial
              ? 'Partial'
              : 'Visible'
          : 'Not visible',
      note: sample.hasLoopContext
          ? partial
              ? 'OpenAPS context is visible, but only limited fields are exposed.'
              : 'OpenAPS context is visible in Nightscout device status.'
          : 'No OpenAPS context is visible in sampled device status.',
    );
  }

  AapsPumpContext _pumpContext(AapsDeviceStatusSample sample) {
    final status = _string(sample.pump['status']) ??
        _string(_map(sample.pump['status'])?['status']) ??
        (sample.hasPumpContext ? 'Visible' : 'Not visible');
    final reservoir = _string(sample.pump['reservoir']) ??
        _string(sample.pump['reservoir_display']) ??
        'Not visible';
    final battery = _string(sample.pump['battery']) ??
        _string(_map(sample.pump['battery'])?['percent']) ??
        'Not visible';
    final partial = sample.hasPumpContext &&
        (reservoir == 'Not visible' || battery == 'Not visible');
    return AapsPumpContext(
      observedAt: sample.observedAt,
      visible: sample.hasPumpContext,
      partial: partial,
      statusLabel: status,
      reservoirLabel: reservoir,
      batteryLabel: battery,
      note: sample.hasPumpContext
          ? partial
              ? 'Pump context is visible with some optional fields missing.'
              : 'Pump status, reservoir, and battery context are visible.'
          : 'Pump context is not exposed by the latest device status.',
    );
  }

  AapsIobCobContext _iobCobContext(AapsDeviceStatusSample sample) {
    return AapsIobCobContext(
      observedAt: sample.observedAt,
      hasIob: sample.hasIobContext,
      hasCob: sample.hasCobContext,
      iobLabel: sample.hasIobContext ? 'Visible' : 'Not visible',
      cobLabel: sample.hasCobContext ? 'Visible' : 'Not visible',
      note: sample.hasIobContext && sample.hasCobContext
          ? 'IOB and COB context are visible from Nightscout.'
          : sample.hasIobContext || sample.hasCobContext
              ? 'Only one of IOB or COB context is visible.'
              : 'IOB and COB context are not exposed in sampled device status.',
    );
  }

  AapsProfileContext _profileContext(AapsDeviceStatusSample sample) {
    return AapsProfileContext(
      observedAt: sample.observedAt,
      visible: sample.hasProfileContext,
      label: sample.hasProfileContext ? 'Visible' : 'Unknown',
      note: sample.hasProfileContext
          ? 'Profile or temp target context is visible.'
          : 'No recent profile or temp target context is visible.',
    );
  }

  Map<String, Object?>? _map(Object? value) {
    if (value is Map) return Map<String, Object?>.from(value);
    return null;
  }

  String? _string(Object? value) {
    if (value == null) return null;
    if (value is num) return value.toString();
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  DateTime? _time(Object? value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is num) {
      final ms = value > 9999999999 ? value.toInt() : (value * 1000).toInt();
      return DateTime.fromMillisecondsSinceEpoch(ms);
    }
    final text = value.toString().trim();
    if (text.isEmpty) return null;
    final parsed = DateTime.tryParse(text);
    return parsed?.toLocal();
  }
}
