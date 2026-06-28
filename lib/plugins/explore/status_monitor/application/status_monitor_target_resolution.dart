enum StatusMonitorTargetSourceKind {
  nightscout,
  xdripLocal,
  none,
}

class StatusMonitorTargetResolution {
  final String subjectId;
  final StatusMonitorTargetSourceKind sourceKind;
  final String? targetId;
  final String sourceLabel;
  final String? baseUrl;
  final String? token;
  final bool enabled;
  final String? unavailableReason;

  const StatusMonitorTargetResolution({
    required this.subjectId,
    required this.sourceKind,
    required this.sourceLabel,
    this.targetId,
    this.baseUrl,
    this.token,
    this.enabled = false,
    this.unavailableReason,
  });

  bool get hasConfiguredSource =>
      sourceKind != StatusMonitorTargetSourceKind.none;

  const StatusMonitorTargetResolution.none({
    required this.subjectId,
    this.unavailableReason =
        'Connect xDrip+ Local or Nightscout API to view link status.',
  })  : sourceKind = StatusMonitorTargetSourceKind.none,
        targetId = null,
        sourceLabel = 'No source',
        baseUrl = null,
        token = null,
        enabled = false;
}
