import '../detail/status_endpoint_probe.dart';

class StatusProbeEvidence {
  final bool configured;
  final bool enabled;
  final String sourceLabel;
  final DateTime? generatedAt;
  final List<StatusEndpointProbe> endpointProbes;
  final String? failureLabel;

  const StatusProbeEvidence({
    required this.configured,
    required this.enabled,
    required this.sourceLabel,
    this.generatedAt,
    this.endpointProbes = const [],
    this.failureLabel,
  });

  const StatusProbeEvidence.none({
    this.sourceLabel = 'Not configured',
    this.failureLabel,
  })  : configured = false,
        enabled = false,
        generatedAt = null,
        endpointProbes = const [];

  bool get available => endpointProbes.any((probe) => probe.reachable);
}
