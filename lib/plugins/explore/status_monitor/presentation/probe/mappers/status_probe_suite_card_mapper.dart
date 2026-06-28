import '../../../domain/probe/status_probe_catalog.dart';
import '../../../domain/probe/status_probe_path_role.dart';
import '../../../domain/probe/status_probe_run_suite_snapshot.dart';
import '../../../domain/probe/status_probe_score_scope.dart';
import '../../../domain/probe/status_probe_state.dart';
import '../../../domain/probe/status_probe_suite_activation_state.dart';
import '../../../domain/probe/status_probe_suite_result.dart';
import '../models/status_probe_score_vm.dart';
import '../models/status_probe_suite_card_vm.dart';
import '../models/status_probe_suite_progress_vm.dart';
import 'status_probe_result_row_mapper.dart';

class StatusProbeSuiteCardMapper {
  final StatusProbeResultRowMapper resultMapper;

  const StatusProbeSuiteCardMapper({
    this.resultMapper = const StatusProbeResultRowMapper(),
  });

  StatusProbeSuiteCardVm map(
    StatusProbeSuiteResult suite,
    StatusProbeCatalog catalog,
  ) {
    final yesCount = suite.results
        .where((result) => result.state == StatusProbeState.healthy)
        .length;
    final total = suite.results.length;
    final noCount = total - yesCount;
    final score = (suite.confidence * 100).round().clamp(0, 100);
    final catalogSuite = _suiteCatalog(suite.suiteId, catalog);
    final role = catalogSuite?.role ?? StatusProbePathRole.core;
    final included = catalogSuite?.scoreScope == StatusProbeScoreScope.included;
    return StatusProbeSuiteCardVm(
      id: suite.suiteId,
      title: suite.definition.label,
      subtitle: _subtitle(suite.suiteId),
      initials: _initials(suite.suiteId),
      tone: _tone(suite.state),
      roleLabel: _roleLabel(role),
      active: true,
      activationLabel: 'Active',
      chips: _chips(suite),
      score: StatusProbeScoreVm(
        score: score,
        yesCount: yesCount,
        totalCount: total,
        noCount: noCount,
        progress: total == 0 ? 0 : yesCount / total,
        includedInCore: included,
      ),
      progress: StatusProbeSuiteProgressVm(
        label: '$total/$total · 100%',
        percent: total == 0 ? 0 : 1,
        completedCount: total,
        runningCount: 0,
        totalCount: total,
      ),
      running: false,
      results: suite.results
          .map((result) => resultMapper.map(result, catalog))
          .toList(growable: false),
    );
  }

  StatusProbeSuiteCardVm mapSnapshot(
    StatusProbeRunSuiteSnapshot suite,
    StatusProbeCatalog catalog,
  ) {
    final catalogSuite =
        suite.catalogEntry ?? _suiteCatalog(suite.suiteId, catalog);
    final role = catalogSuite?.role ?? StatusProbePathRole.core;
    final included = catalogSuite?.scoreScope == StatusProbeScoreScope.included;
    final progress = suite.progress;
    final completedResults = suite.results
        .where((item) => item.result != null)
        .map((item) => item.result!)
        .toList(growable: false);
    final yesCount = completedResults
        .where((result) => result.state == StatusProbeState.healthy)
        .length;
    final noCount = completedResults.length - yesCount;
    final score = suite.suiteResult == null
        ? 0
        : (suite.suiteResult!.confidence * 100).round().clamp(0, 100);
    final active =
        suite.activationState != StatusProbeSuiteActivationState.inactive;
    return StatusProbeSuiteCardVm(
      id: suite.suiteId,
      title: _displayTitle(suite.suiteId, catalogSuite?.display.titleKey),
      subtitle: _displayDescription(
        suite.suiteId,
        catalogSuite?.display.descriptionKey,
      ),
      initials: _initials(suite.suiteId),
      tone: active ? (suite.running ? 'watch' : _tone(suite.state)) : 'unknown',
      roleLabel: _roleLabel(role),
      chips: [
        if (!active) 'not used',
        if (suite.running) 'running',
        if (suite.suiteResult?.latestUsefulEvidenceAt != null)
          'evidence ${_shortAge(suite.suiteResult!.observedAt.difference(suite.suiteResult!.latestUsefulEvidenceAt!))}',
      ],
      active: active,
      activationLabel: _activationLabel(suite.activationState),
      score: StatusProbeScoreVm(
        score: score,
        yesCount: yesCount,
        totalCount: progress.totalCount,
        noCount: noCount,
        progress: progress.percent,
        includedInCore: included,
      ),
      progress: StatusProbeSuiteProgressVm(
        label: progress.label,
        percent: progress.percent,
        completedCount: progress.completedCount,
        runningCount: progress.runningCount,
        totalCount: progress.totalCount,
      ),
      running: suite.running,
      results: suite.results
          .map((result) => resultMapper.mapSnapshot(result, catalog))
          .toList(growable: false),
    );
  }

  StatusProbeSuiteCatalogEntry? _suiteCatalog(
    String suiteId,
    StatusProbeCatalog catalog,
  ) {
    for (final suite in catalog.suites) {
      if (suite.suiteId == suiteId) return suite;
    }
    return null;
  }

  String _subtitle(String suiteId) {
    return switch (suiteId) {
      'common' => 'Phone environment checks used by every data path.',
      'xdrip' =>
        'Primary local hub path. Only required local broadcast checks are shown here.',
      'juggluco' =>
        'Libre app path. Check this only when Juggluco is part of the setup.',
      'nightscout' =>
        'Cloud checks compare Nightscout with the local xDrip+ path.',
      'aaps' => 'Downstream loop context. This is observational only.',
      'watch' =>
        'Optional display path. It should not lower core xDrip+ or Nightscout health.',
      _ => 'Probe suite',
    };
  }

  String _displayTitle(String suiteId, String? value) {
    final raw = value?.trim();
    if (raw == null || raw.isEmpty || raw.startsWith('probe.suite.')) {
      return switch (suiteId) {
        'common' => 'Phone environment',
        'xdrip' => 'xDrip+',
        'juggluco' => 'Juggluco',
        'nightscout' => 'Nightscout',
        'aaps' => 'AAPS',
        'watch' => 'Watch display',
        _ => suiteId,
      };
    }
    return raw;
  }

  String _displayDescription(String suiteId, String? value) {
    final raw = value?.trim();
    if (raw == null || raw.isEmpty || raw.startsWith('probe.suite.')) {
      return _subtitle(suiteId);
    }
    return raw;
  }

  String _initials(String suiteId) {
    return switch (suiteId) {
      'common' => 'PH',
      'xdrip' => 'XD',
      'juggluco' => 'JG',
      'nightscout' => 'NS',
      'aaps' => 'APS',
      'watch' => 'WD',
      _ => suiteId.length >= 2
          ? suiteId.substring(0, 2).toUpperCase()
          : suiteId.toUpperCase(),
    };
  }

  List<String> _chips(StatusProbeSuiteResult suite) {
    return [
      if (suite.suiteId == 'xdrip') 'main path',
      if (suite.suiteId == 'common') 'phone',
      if (suite.suiteId == 'juggluco' || suite.suiteId == 'watch')
        'optional path',
      if (suite.latestUsefulEvidenceAt != null)
        'evidence ${_shortAge(suite.observedAt.difference(suite.latestUsefulEvidenceAt!))}',
    ];
  }

  String _shortAge(Duration age) {
    if (age.inMinutes < 1) return 'just now';
    if (age.inHours < 1) return '${age.inMinutes}m ago';
    return '${age.inHours}h ago';
  }

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

  String _roleLabel(StatusProbePathRole role) {
    return switch (role) {
      StatusProbePathRole.core => 'CORE',
      StatusProbePathRole.optional => 'OPTIONAL',
      StatusProbePathRole.support => 'SUPPORT',
    };
  }

  String _activationLabel(StatusProbeSuiteActivationState state) {
    return switch (state) {
      StatusProbeSuiteActivationState.active => 'Active',
      StatusProbeSuiteActivationState.inactive => 'Not used',
      StatusProbeSuiteActivationState.checking => 'Detecting',
      StatusProbeSuiteActivationState.unknown => 'Unknown',
    };
  }
}
