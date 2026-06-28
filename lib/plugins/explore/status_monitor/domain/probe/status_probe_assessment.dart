import 'status_probe_state.dart';

class StatusProbeAssessment {
  final StatusProbeState state;
  final String summary;
  final double confidence;

  const StatusProbeAssessment({
    required this.state,
    required this.summary,
    required this.confidence,
  });
}
