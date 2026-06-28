import 'status_probe_category.dart';
import 'status_probe_run_mode.dart';
import 'status_probe_state.dart';

class StatusProbeHistorySample {
  final String subjectId;
  final String? sourceTargetId;
  final String probeId;
  final String suiteId;
  final StatusProbeRunMode runMode;
  final StatusProbeCategory category;
  final StatusProbeState state;
  final bool reachable;
  final int? statusCode;
  final Duration elapsed;
  final DateTime at;
  final String summary;
  final double confidence;
  final String? payloadJson;

  const StatusProbeHistorySample({
    required this.subjectId,
    this.sourceTargetId,
    required this.probeId,
    required this.suiteId,
    required this.runMode,
    required this.category,
    required this.state,
    required this.reachable,
    this.statusCode,
    required this.elapsed,
    required this.at,
    required this.summary,
    required this.confidence,
    this.payloadJson,
  });
}
