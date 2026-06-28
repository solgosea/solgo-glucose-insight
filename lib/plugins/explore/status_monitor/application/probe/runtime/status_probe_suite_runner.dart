import '../../../domain/probe/status_probe_context.dart';
import '../../../domain/probe/status_probe_result.dart';
import '../../../domain/probe/status_probe_run_event.dart';
import '../../../domain/probe/status_probe_run_event_type.dart';
import '../../../domain/probe/status_probe_suite_result.dart';
import '../contracts/status_probe_suite.dart';
import '../policies/status_probe_suite_summary_policy.dart';
import 'status_probe_runner.dart';

class StatusProbeSuiteRunner {
  final StatusProbeRunner runner;
  final StatusProbeSuiteSummaryPolicy summaryPolicy;
  final DateTime Function() now;

  const StatusProbeSuiteRunner({
    this.runner = const StatusProbeRunner(),
    this.summaryPolicy = const StatusProbeSuiteSummaryPolicy(),
    DateTime Function()? now,
  }) : now = now ?? DateTime.now;

  Future<StatusProbeSuiteResult> run(
    StatusProbeSuite suite,
    StatusProbeContext context,
  ) async {
    final results = await Future.wait(
      suite.drivers.map((driver) => runner.run(driver, context)),
    );
    return summaryPolicy.summarize(
      definition: suite.definition,
      results: results,
      observedAt: now(),
    );
  }

  Stream<StatusProbeRunEvent> runStream(
    StatusProbeSuite suite,
    StatusProbeContext context,
    String scenarioId,
  ) async* {
    yield StatusProbeRunEvent(
      type: StatusProbeRunEventType.suiteStarted,
      scenarioId: scenarioId,
      suiteId: suite.definition.id,
      occurredAt: now(),
    );

    final results = <StatusProbeResult>[];
    for (final driver in suite.drivers) {
      final probeId = driver.definition.id.value;
      yield StatusProbeRunEvent(
        type: StatusProbeRunEventType.probeStarted,
        scenarioId: scenarioId,
        suiteId: suite.definition.id,
        probeId: probeId,
        occurredAt: now(),
      );
      final result = await runner.run(driver, context);
      results.add(result);
      yield StatusProbeRunEvent(
        type: result.error == null
            ? StatusProbeRunEventType.probeCompleted
            : StatusProbeRunEventType.probeFailed,
        scenarioId: scenarioId,
        suiteId: suite.definition.id,
        probeId: probeId,
        result: result,
        error: result.error,
        occurredAt: now(),
      );
    }

    final suiteResult = summaryPolicy.summarize(
      definition: suite.definition,
      results: results,
      observedAt: now(),
    );
    yield StatusProbeRunEvent(
      type: StatusProbeRunEventType.suiteCompleted,
      scenarioId: scenarioId,
      suiteId: suite.definition.id,
      suiteResult: suiteResult,
      occurredAt: now(),
    );
  }
}
