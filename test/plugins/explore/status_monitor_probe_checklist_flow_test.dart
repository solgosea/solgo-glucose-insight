import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_catalog.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_category.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_definition.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_display_definition.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_id.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_kind.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_run_event.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_run_event_type.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_run_mode.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe_scenario/status_probe_scenario_definition.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_state.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_result.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/presentation/probe/controllers/status_probe_checklist_patch_reducer.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/presentation/probe/controllers/status_probe_checklist_state_machine.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/presentation/probe/mappers/status_probe_checklist_snapshot_mapper.dart';

void main() {
  test('checklist shows catalog probes before any probe result exists', () {
    final now = DateTime(2026, 6, 18, 10);
    final snapshot =
        StatusProbeChecklistStateMachine(now: () => now).initialSnapshot(
      _catalog(),
      scenarioId: 'overview',
    );
    final vm = const StatusProbeChecklistSnapshotMapper().map(snapshot);

    expect(vm.suites, hasLength(1));
    expect(vm.suites.single.progress.label, '0/2 · 0%');
    expect(vm.suites.single.results, hasLength(2));
    expect(vm.suites.single.results.every((row) => row.pending), isTrue);
  });

  test('checklist reducer patches probe progress incrementally', () {
    final now = DateTime(2026, 6, 18, 10);
    final reducer = const StatusProbeChecklistPatchReducer();
    var snapshot =
        StatusProbeChecklistStateMachine(now: () => now).initialSnapshot(
      _catalog(),
      scenarioId: 'overview',
    );

    snapshot = reducer.apply(
      snapshot,
      StatusProbeRunEvent(
        type: StatusProbeRunEventType.runStarted,
        scenarioId: 'overview',
        occurredAt: now,
      ),
    );
    snapshot = reducer.apply(
      snapshot,
      StatusProbeRunEvent(
        type: StatusProbeRunEventType.suiteStarted,
        scenarioId: 'overview',
        suiteId: 'xdrip',
        occurredAt: now,
      ),
    );
    snapshot = reducer.apply(
      snapshot,
      StatusProbeRunEvent(
        type: StatusProbeRunEventType.probeStarted,
        scenarioId: 'overview',
        suiteId: 'xdrip',
        probeId: 'xdrip.package.visible',
        occurredAt: now,
      ),
    );

    var vm = const StatusProbeChecklistSnapshotMapper().map(snapshot);
    expect(vm.suites.single.progress.label, '0/2 · 0%');
    expect(vm.suites.single.results.first.running, isTrue);

    snapshot = reducer.apply(
      snapshot,
      StatusProbeRunEvent(
        type: StatusProbeRunEventType.probeCompleted,
        scenarioId: 'overview',
        suiteId: 'xdrip',
        probeId: 'xdrip.package.visible',
        result: _result('xdrip.package.visible', now),
        occurredAt: now,
      ),
    );

    vm = const StatusProbeChecklistSnapshotMapper().map(snapshot);
    expect(vm.suites.single.progress.label, '1/2 · 50%');
    expect(vm.suites.single.results.first.yes, isTrue);
    expect(vm.suites.single.results.last.pending, isTrue);
  });
}

StatusProbeCatalog _catalog() {
  return const StatusProbeCatalog(
    suites: [
      StatusProbeSuiteCatalogEntry(
        suiteId: 'xdrip',
        kind: StatusProbeKind.xdrip,
        display: StatusProbeDisplayDefinition(
          titleKey: 'xDrip+',
          descriptionKey: 'Primary local hub path.',
        ),
      ),
    ],
    probes: [
      StatusProbeCatalogEntry(
        probeId: 'xdrip.package.visible',
        suiteId: 'xdrip',
        driverId: 'xdrip.package.visible',
        display: StatusProbeDisplayDefinition(
          titleKey: 'xDrip+ package visibility',
          descriptionKey: 'Checks whether xDrip+ is installed.',
        ),
        priority: 1,
      ),
      StatusProbeCatalogEntry(
        probeId: 'xdrip.broadcast.bg_estimate',
        suiteId: 'xdrip',
        driverId: 'xdrip.broadcast.bg_estimate',
        display: StatusProbeDisplayDefinition(
          titleKey: 'BgEstimate broadcast',
          descriptionKey: 'Checks whether local BG broadcast is visible.',
        ),
        priority: 2,
      ),
    ],
    scenarios: [
      StatusProbeScenarioDefinition(
        id: 'overview',
        titleKey: 'overview',
        descriptionKey: 'overview',
        items: [
          StatusProbeScenarioItem(suiteId: 'xdrip', orderIndex: 1),
        ],
      ),
    ],
  );
}

StatusProbeResult _result(String probeId, DateTime now) {
  return StatusProbeResult(
    definition: StatusProbeDefinition(
      id: StatusProbeId(probeId),
      suiteId: 'xdrip',
      label: 'xDrip+ package visibility',
      kind: StatusProbeKind.xdrip,
      category: StatusProbeCategory.package,
      runMode: StatusProbeRunMode.active,
    ),
    state: StatusProbeState.healthy,
    observedAt: now,
    confidence: 1,
    runMode: StatusProbeRunMode.active,
    summary: 'Observed',
  );
}
