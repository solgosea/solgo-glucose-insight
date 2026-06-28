import 'status_probe_severity.dart';

class StatusProbeSignal {
  final String label;
  final String value;
  final StatusProbeSeverity severity;

  const StatusProbeSignal({
    required this.label,
    required this.value,
    this.severity = StatusProbeSeverity.info,
  });

  Map<String, Object?> toJson() => {
        'label': label,
        'value': value,
        'severity': severity.name,
      };
}
