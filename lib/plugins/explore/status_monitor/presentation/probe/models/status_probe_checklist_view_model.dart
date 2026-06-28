import 'status_probe_checklist_summary_vm.dart';
import 'status_probe_suite_card_vm.dart';

class StatusProbeChecklistViewModel {
  final bool loading;
  final String title;
  final String subtitle;
  final String heroTitle;
  final String heroBody;
  final StatusProbeChecklistSummaryVm summary;
  final double? runProgress;
  final List<StatusProbeSuiteCardVm> suites;
  final String? error;

  const StatusProbeChecklistViewModel({
    required this.loading,
    required this.title,
    required this.subtitle,
    required this.heroTitle,
    required this.heroBody,
    required this.summary,
    this.runProgress,
    required this.suites,
    this.error,
  });

  factory StatusProbeChecklistViewModel.initial() {
    return const StatusProbeChecklistViewModel(
      loading: false,
      title: 'Connection checklist',
      subtitle: 'Tick through the key data-path checks',
      heroTitle: 'Check your data path',
      heroBody:
          'Work through the checklist below. Passing items are ticked; items that need attention show a guide or detail action.',
      summary: StatusProbeChecklistSummaryVm(
        passing: '--',
        needsAction: '--',
        optionalPaths: '--',
        lastChecked: '--',
        coreScore: 0,
        coreProgress: 0,
      ),
      suites: [],
    );
  }

  StatusProbeChecklistViewModel copyWith({
    bool? loading,
    String? error,
  }) {
    return StatusProbeChecklistViewModel(
      loading: loading ?? this.loading,
      title: title,
      subtitle: subtitle,
      heroTitle: heroTitle,
      heroBody: heroBody,
      summary: summary,
      runProgress: loading == true ? 0.35 : runProgress,
      suites: suites,
      error: error,
    );
  }
}
