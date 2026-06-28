import 'package:flutter/foundation.dart';
import 'package:smart_xdrip/application/subject/active_subject_service.dart';

import '../../../application/probe/catalog/status_probe_catalog_service.dart';
import '../../../application/probe_scenario/engine/status_probe_scenario_engine.dart';
import '../../../application/probe_scenario/scenarios/status_probe_scenario_ids.dart';
import '../../../application/status_monitor_target_resolver.dart';
import '../../../application/status_monitor_target_resolution.dart';
import '../../../domain/probe/status_probe_context.dart';
import '../../../domain/probe/status_probe_run_snapshot.dart';
import '../mappers/status_probe_checklist_snapshot_mapper.dart';
import '../models/status_probe_checklist_view_model.dart';
import 'status_probe_checklist_patch_reducer.dart';
import 'status_probe_checklist_state_machine.dart';

class StatusProbeChecklistController extends ChangeNotifier {
  final StatusProbeScenarioEngine scenarioEngine;
  final StatusProbeCatalogService catalogService;
  final ActiveSubjectService activeSubjectService;
  final StatusMonitorTargetResolver targetResolver;
  final StatusProbeChecklistSnapshotMapper mapper;
  final StatusProbeChecklistStateMachine stateMachine;
  final StatusProbeChecklistPatchReducer reducer;
  final DateTime Function() now;
  final String? debugNightscoutBaseUrl;
  final String? debugNightscoutToken;

  StatusProbeChecklistViewModel _viewModel =
      StatusProbeChecklistViewModel.initial();
  StatusProbeRunSnapshot? _snapshot;
  bool _running = false;

  StatusProbeChecklistController({
    required this.scenarioEngine,
    required this.catalogService,
    required this.activeSubjectService,
    required this.targetResolver,
    this.mapper = const StatusProbeChecklistSnapshotMapper(),
    StatusProbeChecklistStateMachine? stateMachine,
    this.reducer = const StatusProbeChecklistPatchReducer(),
    this.debugNightscoutBaseUrl,
    this.debugNightscoutToken,
    DateTime Function()? now,
  })  : stateMachine = stateMachine ?? StatusProbeChecklistStateMachine(),
        now = now ?? DateTime.now;

  StatusProbeChecklistViewModel get viewModel => _viewModel;

  Future<void> load() async {
    final catalog = await catalogService.load();
    _snapshot = stateMachine.initialSnapshot(catalog);
    _viewModel = mapper.map(_snapshot!);
    notifyListeners();
    await runChecks();
  }

  Future<void> runChecks() async {
    if (_running) return;
    _running = true;
    var snapshot = _snapshot;
    if (snapshot == null) {
      final catalog = await catalogService.load();
      snapshot = stateMachine.initialSnapshot(catalog);
      _snapshot = snapshot;
    } else {
      snapshot = stateMachine.initialSnapshot(snapshot.catalog);
      _snapshot = snapshot;
    }
    _viewModel = mapper.map(snapshot);
    notifyListeners();
    try {
      final subject = activeSubjectService.current;
      final target = _debugNightscoutTarget(subject.id) ??
          await targetResolver.resolve(subject);
      await for (final event in scenarioEngine.runStream(
        StatusProbeContext(
          subjectId: subject.id,
          now: now(),
          target: target,
        ),
        StatusProbeScenarioIds.overview,
      )) {
        snapshot = reducer.apply(snapshot!, event);
        _snapshot = snapshot;
        _viewModel = mapper.map(snapshot);
        notifyListeners();
      }
    } catch (error) {
      final current = _snapshot;
      if (current != null) {
        _snapshot = current.copyWith(
          running: false,
          completed: false,
          generatedAt: now(),
          error: error,
        );
        _viewModel = mapper.map(_snapshot!);
      } else {
        _viewModel = _viewModel.copyWith(
          loading: false,
          error: error.toString(),
        );
      }
    } finally {
      _running = false;
    }
    notifyListeners();
  }

  StatusMonitorTargetResolution? _debugNightscoutTarget(String subjectId) {
    final baseUrl = debugNightscoutBaseUrl?.trim();
    if (baseUrl == null || baseUrl.isEmpty) return null;
    return StatusMonitorTargetResolution(
      subjectId: subjectId,
      sourceKind: StatusMonitorTargetSourceKind.nightscout,
      targetId: 'debug:probe-nightscout',
      sourceLabel: 'Probe Nightscout',
      baseUrl: baseUrl,
      token: debugNightscoutToken,
      enabled: true,
    );
  }
}
