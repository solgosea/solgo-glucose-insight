import '../../status_monitor_target_resolution.dart';

class StatusComponentEvidencePlan {
  final String subjectId;
  final StatusMonitorTargetResolution? xdripLocal;
  final StatusMonitorTargetResolution? nightscout;

  const StatusComponentEvidencePlan({
    required this.subjectId,
    this.xdripLocal,
    this.nightscout,
  });
}
