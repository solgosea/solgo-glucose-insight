import '../../../domain/probe/status_probe_run_event.dart';
import '../../../domain/probe/status_probe_run_event_type.dart';
import '../../../domain/probe/status_probe_run_result_snapshot.dart';
import '../../../domain/probe/status_probe_run_snapshot.dart';
import '../../../domain/probe/status_probe_run_suite_snapshot.dart';
import '../../../domain/probe/status_probe_state.dart';
import '../../../domain/probe/status_probe_suite_activation_state.dart';

class StatusProbeChecklistPatchReducer {
  const StatusProbeChecklistPatchReducer();

  StatusProbeRunSnapshot apply(
    StatusProbeRunSnapshot snapshot,
    StatusProbeRunEvent event,
  ) {
    return switch (event.type) {
      StatusProbeRunEventType.runStarted => snapshot.copyWith(
          running: true,
          completed: false,
          generatedAt: event.occurredAt,
        ),
      StatusProbeRunEventType.suiteStarted =>
        _patchSuite(snapshot, event.suiteId, (suite) {
          return suite.copyWith(running: true, state: StatusProbeState.waiting);
        }),
      StatusProbeRunEventType.probeStarted =>
        _patchProbe(snapshot, event.suiteId, event.probeId, (probe) {
          return probe.copyWith(phase: StatusProbeRunResultPhase.running);
        }),
      StatusProbeRunEventType.probeCompleted ||
      StatusProbeRunEventType.probeFailed =>
        _patchProbe(snapshot, event.suiteId, event.probeId, (probe) {
          return probe.copyWith(
            phase: event.type == StatusProbeRunEventType.probeFailed
                ? StatusProbeRunResultPhase.failed
                : StatusProbeRunResultPhase.completed,
            result: event.result,
          );
        }),
      StatusProbeRunEventType.probeSkipped =>
        _patchProbe(snapshot, event.suiteId, event.probeId, (probe) {
          return probe.copyWith(
            phase: StatusProbeRunResultPhase.skipped,
            result: event.result,
          );
        }),
      StatusProbeRunEventType.suiteCompleted =>
        _patchSuite(snapshot, event.suiteId, (suite) {
          final active = event.suiteResult?.results
                  .any((result) => result.state == StatusProbeState.healthy) ??
              false;
          return suite.copyWith(
            running: false,
            suiteResult: event.suiteResult,
            state: event.suiteResult?.state ?? suite.state,
            activationState: suite.catalogEntry?.scoreScope.name == 'excluded'
                ? active
                    ? StatusProbeSuiteActivationState.active
                    : StatusProbeSuiteActivationState.inactive
                : StatusProbeSuiteActivationState.active,
            activationReason: active ? null : 'Not used for this setup',
          );
        }),
      StatusProbeRunEventType.runCompleted => snapshot.copyWith(
          running: false,
          completed: true,
          generatedAt: event.occurredAt,
          bundle: event.scenarioResult?.bundle,
        ),
      StatusProbeRunEventType.runFailed => snapshot.copyWith(
          running: false,
          completed: false,
          generatedAt: event.occurredAt,
          error: event.error,
        ),
    };
  }

  StatusProbeRunSnapshot _patchSuite(
    StatusProbeRunSnapshot snapshot,
    String? suiteId,
    StatusProbeRunSuiteSnapshot Function(StatusProbeRunSuiteSnapshot suite)
        patch,
  ) {
    if (suiteId == null) return snapshot;
    return snapshot.copyWith(
      suites: [
        for (final suite in snapshot.suites)
          suite.suiteId == suiteId ? patch(suite) : suite,
      ],
    );
  }

  StatusProbeRunSnapshot _patchProbe(
    StatusProbeRunSnapshot snapshot,
    String? suiteId,
    String? probeId,
    StatusProbeRunResultSnapshot Function(StatusProbeRunResultSnapshot probe)
        patch,
  ) {
    if (suiteId == null || probeId == null) return snapshot;
    return _patchSuite(snapshot, suiteId, (suite) {
      return suite.copyWith(
        results: [
          for (final probe in suite.results)
            probe.probeId == probeId ? patch(probe) : probe,
        ],
      );
    });
  }
}
