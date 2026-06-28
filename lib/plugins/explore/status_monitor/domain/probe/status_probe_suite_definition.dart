import 'status_probe_definition.dart';
import 'status_probe_kind.dart';

class StatusProbeSuiteDefinition {
  final String id;
  final String label;
  final StatusProbeKind kind;
  final List<StatusProbeDefinition> probes;

  const StatusProbeSuiteDefinition({
    required this.id,
    required this.label,
    required this.kind,
    required this.probes,
  });
}
