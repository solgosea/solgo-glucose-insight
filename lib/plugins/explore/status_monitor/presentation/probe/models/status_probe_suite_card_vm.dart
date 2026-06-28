import 'status_probe_result_row_vm.dart';
import 'status_probe_score_vm.dart';
import 'status_probe_suite_progress_vm.dart';

class StatusProbeSuiteCardVm {
  final String id;
  final String title;
  final String subtitle;
  final String initials;
  final String tone;
  final String roleLabel;
  final bool active;
  final String activationLabel;
  final List<String> chips;
  final StatusProbeScoreVm score;
  final StatusProbeSuiteProgressVm progress;
  final bool running;
  final List<StatusProbeResultRowVm> results;

  const StatusProbeSuiteCardVm({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.initials,
    required this.tone,
    required this.roleLabel,
    this.active = true,
    this.activationLabel = 'Active',
    required this.chips,
    required this.score,
    required this.progress,
    this.running = false,
    required this.results,
  });
}
