import '../../../domain/probe/status_probe_catalog.dart';
import '../../../domain/probe_scenario/status_probe_scenario_result.dart';
import '../models/status_probe_checklist_summary_vm.dart';
import '../models/status_probe_checklist_view_model.dart';
import 'status_probe_suite_card_mapper.dart';

class StatusProbeChecklistViewModelMapper {
  final StatusProbeSuiteCardMapper suiteMapper;

  const StatusProbeChecklistViewModelMapper({
    this.suiteMapper = const StatusProbeSuiteCardMapper(),
  });

  StatusProbeChecklistViewModel map(
    StatusProbeScenarioResult result,
    StatusProbeCatalog catalog,
  ) {
    final breakdown = result.breakdown;
    return StatusProbeChecklistViewModel(
      loading: false,
      title: 'Connection checklist',
      subtitle: 'Tick through the key data-path checks',
      heroTitle: 'Check your data path',
      heroBody:
          'Work through the checklist below. Passing items are ticked; items that need attention show a guide or detail action.',
      summary: StatusProbeChecklistSummaryVm(
        passing: '${breakdown.corePassing}/${breakdown.coreTotal}',
        needsAction: '${breakdown.coreNeedsAction} No',
        optionalPaths:
            '${breakdown.optionalActive}/${breakdown.optionalTotal} active',
        lastChecked: _time(result.bundle.generatedAt),
        coreProgress: breakdown.coreProgress,
        coreScore: breakdown.coreScore,
      ),
      suites: result.bundle.suites
          .map((suite) => suiteMapper.map(suite, catalog))
          .toList(growable: false),
    );
  }

  String _time(DateTime value) {
    final local = value.toLocal();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
