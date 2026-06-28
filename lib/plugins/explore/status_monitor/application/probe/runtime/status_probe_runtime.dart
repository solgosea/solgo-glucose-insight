import '../../../domain/probe/status_probe_context.dart';
import '../../../domain/probe/status_probe_evidence_bundle.dart';
import '../builders/status_probe_evidence_bundle_builder.dart';
import '../history/status_probe_history_recorder.dart';
import 'status_probe_event_bus.dart';
import 'status_probe_registry.dart';
import 'status_probe_result_cache.dart';
import 'status_probe_suite_runner.dart';

class StatusProbeRuntime {
  final StatusProbeRegistry registry;
  final StatusProbeSuiteRunner suiteRunner;
  final StatusProbeEvidenceBundleBuilder bundleBuilder;
  final StatusProbeResultCache cache;
  final StatusProbeEventBus eventBus;
  final StatusProbeHistoryRecorder? historyRecorder;
  final DateTime Function() now;

  const StatusProbeRuntime({
    required this.registry,
    this.suiteRunner = const StatusProbeSuiteRunner(),
    this.bundleBuilder = const StatusProbeEvidenceBundleBuilder(),
    required this.cache,
    required this.eventBus,
    this.historyRecorder,
    DateTime Function()? now,
  }) : now = now ?? DateTime.now;

  Future<StatusProbeEvidenceBundle> runAll(StatusProbeContext context) async {
    final suites = await Future.wait(
      registry.suites.map((suite) => suiteRunner.run(suite, context)),
    );
    final bundle = bundleBuilder.build(
      subjectId: context.subjectId,
      generatedAt: now(),
      suites: suites,
    );
    await historyRecorder?.record(context: context, bundle: bundle);
    cache.update(bundle);
    eventBus.publish(bundle);
    return bundle;
  }

  Future<StatusProbeEvidenceBundle> runSuites(
    StatusProbeContext context,
    List<String> suiteIds,
  ) async {
    final suites = registry.suites
        .where((suite) => suiteIds.contains(suite.definition.id))
        .toList(growable: false);
    final results = await Future.wait(
      suites.map((suite) => suiteRunner.run(suite, context)),
    );
    final bundle = bundleBuilder.build(
      subjectId: context.subjectId,
      generatedAt: now(),
      suites: results,
    );
    await historyRecorder?.record(context: context, bundle: bundle);
    cache.update(bundle);
    eventBus.publish(bundle);
    return bundle;
  }
}
