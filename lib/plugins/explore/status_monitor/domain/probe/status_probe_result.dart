import 'status_probe_definition.dart';
import 'status_probe_evidence.dart';
import 'status_probe_run_mode.dart';
import 'status_probe_signal.dart';
import 'status_probe_source_ref.dart';
import 'status_probe_state.dart';

class StatusProbeResult {
  final StatusProbeDefinition definition;
  final StatusProbeState state;
  final DateTime observedAt;
  final double confidence;
  final StatusProbeRunMode runMode;
  final String summary;
  final Duration? elapsed;
  final Object? error;
  final List<StatusProbeSignal> signals;
  final List<StatusProbeEvidence> evidence;
  final List<StatusProbeSourceRef> sourceRefs;

  const StatusProbeResult({
    required this.definition,
    required this.state,
    required this.observedAt,
    required this.confidence,
    required this.runMode,
    required this.summary,
    this.elapsed,
    this.error,
    this.signals = const [],
    this.evidence = const [],
    this.sourceRefs = const [],
  });

  String get probeId => definition.id.value;
  String get suiteId => definition.suiteId;

  factory StatusProbeResult.error({
    required StatusProbeDefinition definition,
    required DateTime observedAt,
    required Object error,
    Duration? elapsed,
  }) {
    return StatusProbeResult(
      definition: definition,
      state: StatusProbeState.issue,
      observedAt: observedAt,
      confidence: 0,
      runMode: definition.runMode,
      summary: 'Probe failed',
      elapsed: elapsed,
      error: error,
      sourceRefs: [
        StatusProbeSourceRef(
          source: definition.id.value,
          path: 'exception',
          detail: error.toString(),
        ),
      ],
    );
  }

  Map<String, Object?> toJson() => {
        'probeId': probeId,
        'suiteId': suiteId,
        'state': state.name,
        'observedAtMs': observedAt.millisecondsSinceEpoch,
        'confidence': confidence,
        'runMode': runMode.name,
        'summary': summary,
        'elapsedMs': elapsed?.inMilliseconds,
        'signals': signals.map((signal) => signal.toJson()).toList(),
        'evidence': evidence.map((item) => item.toJson()).toList(),
        'sourceRefs': sourceRefs.map((ref) => ref.toJson()).toList(),
      };
}
