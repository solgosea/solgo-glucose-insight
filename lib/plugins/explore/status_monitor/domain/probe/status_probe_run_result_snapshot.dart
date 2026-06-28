import 'status_probe_catalog.dart';
import 'status_probe_result.dart';

enum StatusProbeRunResultPhase {
  pending,
  running,
  completed,
  failed,
  skipped,
}

class StatusProbeRunResultSnapshot {
  final String probeId;
  final String suiteId;
  final StatusProbeCatalogEntry? catalogEntry;
  final StatusProbeResult? result;
  final StatusProbeRunResultPhase phase;

  const StatusProbeRunResultSnapshot({
    required this.probeId,
    required this.suiteId,
    this.catalogEntry,
    this.result,
    required this.phase,
  });

  bool get running => phase == StatusProbeRunResultPhase.running;

  bool get completed =>
      phase == StatusProbeRunResultPhase.completed ||
      phase == StatusProbeRunResultPhase.failed ||
      phase == StatusProbeRunResultPhase.skipped;

  StatusProbeRunResultSnapshot copyWith({
    StatusProbeResult? result,
    StatusProbeRunResultPhase? phase,
  }) {
    return StatusProbeRunResultSnapshot(
      probeId: probeId,
      suiteId: suiteId,
      catalogEntry: catalogEntry,
      result: result ?? this.result,
      phase: phase ?? this.phase,
    );
  }
}
