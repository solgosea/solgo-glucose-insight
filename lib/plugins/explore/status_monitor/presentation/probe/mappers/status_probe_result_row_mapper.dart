import '../../../domain/probe/status_probe_catalog.dart';
import '../../../domain/probe/status_probe_result.dart';
import '../../../domain/probe/status_probe_run_result_snapshot.dart';
import '../../../domain/probe/status_probe_state.dart';
import '../models/status_probe_guide_action_vm.dart';
import '../models/status_probe_result_row_vm.dart';

class StatusProbeResultRowMapper {
  const StatusProbeResultRowMapper();

  StatusProbeResultRowVm map(
    StatusProbeResult result,
    StatusProbeCatalog catalog,
  ) {
    final catalogEntry = _catalogEntry(result, catalog);
    final needsGuide = !_isYes(result.state);
    final guideRoute = catalogEntry?.display.guideRoute;
    return StatusProbeResultRowVm(
      id: result.probeId,
      title: _title(result),
      body: result.summary,
      code: _code(result),
      state: _tone(result.state),
      yes: _isYes(result.state),
      guideAction: needsGuide && guideRoute != null && guideRoute.isNotEmpty
          ? StatusProbeGuideActionVm(
              label: guideRoute.contains('guide') ? 'Guide' : 'Detail',
              route: guideRoute,
            )
          : null,
    );
  }

  StatusProbeResultRowVm mapSnapshot(
    StatusProbeRunResultSnapshot snapshot,
    StatusProbeCatalog catalog,
  ) {
    if (snapshot.phase == StatusProbeRunResultPhase.skipped) {
      final entry =
          snapshot.catalogEntry ?? _catalogEntryById(snapshot.probeId, catalog);
      return StatusProbeResultRowVm(
        id: snapshot.probeId,
        title: entry?.display.titleKey ?? snapshot.probeId,
        body: 'Not used for this detected setup.',
        code: _codeFromCatalog(entry),
        state: 'unknown',
        yes: false,
        completed: true,
      );
    }
    final result = snapshot.result;
    if (result != null) return map(result, catalog);
    final entry =
        snapshot.catalogEntry ?? _catalogEntryById(snapshot.probeId, catalog);
    final running = snapshot.phase == StatusProbeRunResultPhase.running;
    final skipped = snapshot.phase == StatusProbeRunResultPhase.skipped;
    return StatusProbeResultRowVm(
      id: snapshot.probeId,
      title: entry?.display.titleKey ?? snapshot.probeId,
      body: skipped
          ? 'Not used for this detected setup.'
          : running
              ? 'Checking this item now.'
              : 'Waiting to run this check.',
      code: _codeFromCatalog(entry),
      state: running ? 'watch' : 'unknown',
      yes: false,
      pending: snapshot.phase == StatusProbeRunResultPhase.pending,
      running: running,
      completed: skipped,
      guideAction: null,
    );
  }

  StatusProbeCatalogEntry? _catalogEntry(
    StatusProbeResult result,
    StatusProbeCatalog catalog,
  ) {
    for (final entry in catalog.probes) {
      if (entry.probeId == result.probeId) return entry;
    }
    return null;
  }

  StatusProbeCatalogEntry? _catalogEntryById(
    String probeId,
    StatusProbeCatalog catalog,
  ) {
    for (final entry in catalog.probes) {
      if (entry.probeId == probeId) return entry;
    }
    return null;
  }

  String _title(StatusProbeResult result) {
    return result.definition.label;
  }

  String _code(StatusProbeResult result) {
    return switch (result.definition.category.name) {
      'package' => 'PKG',
      'broadcast' => 'BG',
      'freshness' => 'AGE',
      'api' => 'API',
      'downstream' => 'SRC',
      'network' => 'NET',
      'bluetooth' => 'BT',
      'permission' => 'PERM',
      'power' => 'PWR',
      'runtime' => 'RUN',
      _ => result.definition.category.name.toUpperCase(),
    };
  }

  String _codeFromCatalog(StatusProbeCatalogEntry? entry) {
    final driverId = entry?.driverId ?? entry?.probeId ?? 'probe';
    final normalized = driverId.toLowerCase();
    if (normalized.contains('package')) return 'PKG';
    if (normalized.contains('broadcast')) return 'BG';
    if (normalized.contains('freshness')) return 'AGE';
    if (normalized.contains('status') || normalized.contains('entries')) {
      return 'API';
    }
    if (normalized.contains('network')) return 'NET';
    if (normalized.contains('bluetooth')) return 'BT';
    if (normalized.contains('permission')) return 'PERM';
    if (normalized.contains('battery')) return 'PWR';
    return 'CHK';
  }

  bool _isYes(StatusProbeState state) => state == StatusProbeState.healthy;

  String _tone(StatusProbeState state) {
    return switch (state) {
      StatusProbeState.healthy => 'healthy',
      StatusProbeState.watch => 'watch',
      StatusProbeState.issue => 'issue',
      StatusProbeState.unknown ||
      StatusProbeState.notConfigured ||
      StatusProbeState.waiting ||
      StatusProbeState.notObserved =>
        'unknown',
    };
  }
}
