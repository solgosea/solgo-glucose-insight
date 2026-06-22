import '../aaps/aaps_device_status_sample.dart';
import '../aaps/aaps_iob_cob_context.dart';
import '../aaps/aaps_loop_context.dart';
import '../aaps/aaps_profile_context.dart';
import '../aaps/aaps_pump_context.dart';

class AapsEvidence {
  final bool configured;
  final bool nightscoutReachable;
  final List<AapsDeviceStatusSample> deviceStatusSamples;
  final AapsLoopContext? latestLoop;
  final AapsPumpContext? latestPump;
  final AapsIobCobContext? latestIobCob;
  final AapsProfileContext? latestProfile;
  final DateTime generatedAt;
  final String sourceLabel;
  final String? sanitizedFailureLabel;

  const AapsEvidence({
    required this.configured,
    required this.nightscoutReachable,
    required this.deviceStatusSamples,
    required this.generatedAt,
    this.latestLoop,
    this.latestPump,
    this.latestIobCob,
    this.latestProfile,
    this.sourceLabel = 'Nightscout device status',
    this.sanitizedFailureLabel,
  });

  bool get hasAapsContext =>
      latestLoop?.visible == true ||
      latestPump?.visible == true ||
      latestIobCob != null ||
      latestProfile?.visible == true;

  DateTime? get latestContextAt {
    final times = [
      latestLoop?.observedAt,
      latestPump?.observedAt,
      latestIobCob?.observedAt,
      latestProfile?.observedAt,
    ].whereType<DateTime>().toList(growable: false);
    if (times.isEmpty) return null;
    times.sort();
    return times.last;
  }
}
