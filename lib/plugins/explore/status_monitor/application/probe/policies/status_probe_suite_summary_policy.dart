import '../../../domain/probe/status_probe_result.dart';
import '../../../domain/probe/status_probe_source_ref.dart';
import '../../../domain/probe/status_probe_state.dart';
import '../../../domain/probe/status_probe_suite_definition.dart';
import '../../../domain/probe/status_probe_suite_result.dart';

class StatusProbeSuiteSummaryPolicy {
  const StatusProbeSuiteSummaryPolicy();

  StatusProbeSuiteResult summarize({
    required StatusProbeSuiteDefinition definition,
    required List<StatusProbeResult> results,
    required DateTime observedAt,
  }) {
    final requiredResults = results
        .where((result) => result.definition.requiredForCorePath)
        .toList(growable: false);
    final requiredFailures = requiredResults
        .where((result) =>
            result.state == StatusProbeState.issue ||
            result.state == StatusProbeState.notConfigured)
        .toList(growable: false);
    final anyWatch = results.any((result) => result.state.isProblem);
    final useful = results
        .where((result) => result.state.hasUsefulEvidence)
        .toList(growable: false);
    final state = requiredFailures.isNotEmpty
        ? StatusProbeState.issue
        : useful.isEmpty
            ? StatusProbeState.waiting
            : anyWatch
                ? StatusProbeState.watch
                : StatusProbeState.healthy;
    final confidence = results.isEmpty
        ? 0.0
        : results
                .map((result) => result.confidence)
                .fold<double>(0, (sum, value) => sum + value) /
            results.length;
    final latestUseful = useful
        .map((result) => result.observedAt)
        .fold<DateTime?>(null, (latest, value) {
      if (latest == null || value.isAfter(latest)) return value;
      return latest;
    });
    return StatusProbeSuiteResult(
      definition: definition,
      state: state,
      summary: _summary(state, useful.length, results.length),
      observedAt: observedAt,
      latestUsefulEvidenceAt: latestUseful,
      confidence: confidence.clamp(0, 1),
      results: results,
      sourceRefs: _sourceRefs(results),
    );
  }

  String _summary(StatusProbeState state, int useful, int total) {
    final prefix = switch (state) {
      StatusProbeState.healthy => 'All required probe evidence is available.',
      StatusProbeState.watch => 'Some probe evidence needs review.',
      StatusProbeState.issue => 'Required probe evidence is failing.',
      StatusProbeState.waiting => 'Waiting for probe evidence.',
      StatusProbeState.notConfigured => 'Probe target is not configured.',
      StatusProbeState.notObserved => 'Probe evidence has not been observed.',
      StatusProbeState.unknown => 'Probe state is unknown.',
    };
    return '$prefix $useful/$total probes have useful evidence.';
  }

  List<StatusProbeSourceRef> _sourceRefs(List<StatusProbeResult> results) {
    return results
        .expand((result) => result.sourceRefs)
        .toList(growable: false);
  }
}
