import '../../application/status_monitor_target_resolution.dart';

class StatusProbeContext {
  final String subjectId;
  final DateTime now;
  final StatusMonitorTargetResolution target;

  const StatusProbeContext({
    required this.subjectId,
    required this.now,
    required this.target,
  });
}
