import 'status_probe_catalog.dart';
import 'status_probe_run_progress.dart';
import 'status_probe_run_result_snapshot.dart';
import 'status_probe_state.dart';
import 'status_probe_suite_activation_state.dart';
import 'status_probe_suite_result.dart';

class StatusProbeRunSuiteSnapshot {
  final String suiteId;
  final StatusProbeSuiteCatalogEntry? catalogEntry;
  final StatusProbeState state;
  final StatusProbeSuiteActivationState activationState;
  final String? activationReason;
  final bool running;
  final StatusProbeSuiteResult? suiteResult;
  final List<StatusProbeRunResultSnapshot> results;

  const StatusProbeRunSuiteSnapshot({
    required this.suiteId,
    this.catalogEntry,
    required this.state,
    this.activationState = StatusProbeSuiteActivationState.unknown,
    this.activationReason,
    required this.running,
    this.suiteResult,
    required this.results,
  });

  StatusProbeRunProgress get progress => StatusProbeRunProgress(
        completedCount: results.where((item) => item.completed).length,
        runningCount: results.where((item) => item.running).length,
        totalCount: results.length,
      );

  StatusProbeRunSuiteSnapshot copyWith({
    StatusProbeState? state,
    StatusProbeSuiteActivationState? activationState,
    String? activationReason,
    bool? running,
    StatusProbeSuiteResult? suiteResult,
    List<StatusProbeRunResultSnapshot>? results,
  }) {
    return StatusProbeRunSuiteSnapshot(
      suiteId: suiteId,
      catalogEntry: catalogEntry,
      state: state ?? this.state,
      activationState: activationState ?? this.activationState,
      activationReason: activationReason ?? this.activationReason,
      running: running ?? this.running,
      suiteResult: suiteResult ?? this.suiteResult,
      results: results ?? this.results,
    );
  }
}
