import '../detail/status_endpoint_probe.dart';

class StatusDeviceServiceEvidence {
  final bool configured;
  final bool enabled;
  final String? sourceTargetId;
  final String sourceLabel;
  final DateTime? generatedAt;
  final StatusEndpointProbe? probe;
  final String? failureLabel;

  const StatusDeviceServiceEvidence({
    required this.configured,
    required this.enabled,
    this.sourceTargetId,
    required this.sourceLabel,
    this.generatedAt,
    this.probe,
    this.failureLabel,
  });

  const StatusDeviceServiceEvidence.none({
    this.sourceLabel = 'Device service',
    this.failureLabel,
  })  : configured = false,
        enabled = false,
        sourceTargetId = null,
        generatedAt = null,
        probe = null;

  bool get reachable => probe?.reachable == true;
}
