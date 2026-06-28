import 'status_observation_label.dart';
import 'status_observation_severity.dart';
import 'status_observation_state.dart';

class StatusObservationMappingResult {
  final StatusObservationState state;
  final StatusObservationSeverity severity;
  final StatusObservationLabel label;

  const StatusObservationMappingResult({
    required this.state,
    required this.severity,
    required this.label,
  });
}
