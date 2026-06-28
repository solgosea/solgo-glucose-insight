import 'status_probe_category.dart';
import 'status_probe_id.dart';
import 'status_probe_kind.dart';
import 'status_probe_run_mode.dart';

class StatusProbeDefinition {
  final StatusProbeId id;
  final String suiteId;
  final String label;
  final StatusProbeKind kind;
  final StatusProbeCategory category;
  final StatusProbeRunMode runMode;
  final Duration timeout;
  final bool requiredForCorePath;

  const StatusProbeDefinition({
    required this.id,
    required this.suiteId,
    required this.label,
    required this.kind,
    required this.category,
    required this.runMode,
    this.timeout = const Duration(seconds: 5),
    this.requiredForCorePath = false,
  });
}
