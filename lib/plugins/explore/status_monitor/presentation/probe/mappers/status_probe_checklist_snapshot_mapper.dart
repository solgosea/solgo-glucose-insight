import '../../../domain/probe/status_probe_run_snapshot.dart';
import '../../../domain/probe/status_probe_path_role.dart';
import '../../../domain/probe/status_probe_state.dart';
import '../../../domain/probe/status_probe_suite_activation_state.dart';
import '../models/status_probe_checklist_summary_vm.dart';
import '../models/status_probe_checklist_view_model.dart';
import 'status_probe_suite_card_mapper.dart';

class StatusProbeChecklistSnapshotMapper {
  final StatusProbeSuiteCardMapper suiteMapper;

  const StatusProbeChecklistSnapshotMapper({
    this.suiteMapper = const StatusProbeSuiteCardMapper(),
  });

  StatusProbeChecklistViewModel map(StatusProbeRunSnapshot snapshot) {
    final progress = snapshot.progress;
    final completedResults = snapshot.suites
        .expand((suite) => suite.results)
        .where((result) => result.result != null)
        .map((result) => result.result!)
        .toList(growable: false);
    final passing = completedResults
        .where((result) => result.state == StatusProbeState.healthy)
        .length;
    final needsAction = completedResults
        .where((result) => result.state != StatusProbeState.healthy)
        .length;
    final optionalActive = snapshot.suites
        .where(
            (suite) => suite.catalogEntry?.role == StatusProbePathRole.optional)
        .where((suite) =>
            suite.activationState == StatusProbeSuiteActivationState.active)
        .length;
    final optionalTotal = snapshot.suites
        .where(
            (suite) => suite.catalogEntry?.role == StatusProbePathRole.optional)
        .length;
    return StatusProbeChecklistViewModel(
      loading: snapshot.running,
      title: 'Connection checklist',
      subtitle: snapshot.running
          ? 'Running checks ${progress.label}'
          : 'Tick through the key data-path checks',
      heroTitle: 'Check your data path',
      heroBody:
          'Work through the checklist below. Passing items are ticked; items that need attention show a guide or detail action.',
      summary: StatusProbeChecklistSummaryVm(
        passing:
            progress.totalCount == 0 ? '--' : '$passing/${progress.totalCount}',
        needsAction: snapshot.completed ? '$needsAction No' : 'Checking',
        optionalPaths: '$optionalActive/$optionalTotal active',
        lastChecked: _time(snapshot.generatedAt),
        coreProgress: progress.percent,
        coreScore: _score(snapshot),
      ),
      runProgress: progress.percent,
      suites: snapshot.suites
          .map((suite) => suiteMapper.mapSnapshot(suite, snapshot.catalog))
          .toList(growable: false),
      error: snapshot.error?.toString(),
    );
  }

  int _score(StatusProbeRunSnapshot snapshot) {
    if (snapshot.bundle != null) {
      final values = snapshot.suites
          .where((suite) => suite.catalogEntry?.scoreScope.name == 'included')
          .map((suite) => suite.suiteResult?.confidence)
          .whereType<double>()
          .toList(growable: false);
      if (values.isEmpty) return 0;
      return (values.reduce((a, b) => a + b) / values.length * 100)
          .round()
          .clamp(0, 100);
    }
    final progress = snapshot.progress;
    return (progress.percent * 100).round().clamp(0, 100);
  }

  String _time(DateTime value) {
    final local = value.toLocal();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
