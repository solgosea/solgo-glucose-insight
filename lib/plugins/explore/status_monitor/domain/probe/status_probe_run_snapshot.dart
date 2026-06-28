import 'status_probe_catalog.dart';
import 'status_probe_evidence_bundle.dart';
import 'status_probe_run_progress.dart';
import 'status_probe_run_suite_snapshot.dart';

class StatusProbeRunSnapshot {
  final String scenarioId;
  final StatusProbeCatalog catalog;
  final DateTime startedAt;
  final DateTime generatedAt;
  final bool running;
  final bool completed;
  final List<StatusProbeRunSuiteSnapshot> suites;
  final StatusProbeEvidenceBundle? bundle;
  final Object? error;

  const StatusProbeRunSnapshot({
    required this.scenarioId,
    required this.catalog,
    required this.startedAt,
    required this.generatedAt,
    required this.running,
    required this.completed,
    required this.suites,
    this.bundle,
    this.error,
  });

  StatusProbeRunProgress get progress {
    var completed = 0;
    var runningCount = 0;
    var total = 0;
    for (final suite in suites) {
      final suiteProgress = suite.progress;
      completed += suiteProgress.completedCount;
      runningCount += suiteProgress.runningCount;
      total += suiteProgress.totalCount;
    }
    return StatusProbeRunProgress(
      completedCount: completed,
      runningCount: runningCount,
      totalCount: total,
    );
  }

  StatusProbeRunSnapshot copyWith({
    DateTime? generatedAt,
    bool? running,
    bool? completed,
    List<StatusProbeRunSuiteSnapshot>? suites,
    StatusProbeEvidenceBundle? bundle,
    Object? error,
  }) {
    return StatusProbeRunSnapshot(
      scenarioId: scenarioId,
      catalog: catalog,
      startedAt: startedAt,
      generatedAt: generatedAt ?? this.generatedAt,
      running: running ?? this.running,
      completed: completed ?? this.completed,
      suites: suites ?? this.suites,
      bundle: bundle ?? this.bundle,
      error: error,
    );
  }
}
