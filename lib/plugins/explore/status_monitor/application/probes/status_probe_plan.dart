import '../status_monitor_target_resolution.dart';

class StatusProbePlan {
  final String subjectId;
  final StatusMonitorTargetResolution? xdripLocal;
  final StatusMonitorTargetResolution? nightscout;

  const StatusProbePlan({
    required this.subjectId,
    this.xdripLocal,
    this.nightscout,
  });
}
