import '../../../../domain/detail/status_signal_summary.dart';
import '../../../../domain/scoring/status_component_score.dart';
import '../../../../domain/status_level.dart';
import '../../../../domain/trace/status_evidence_trace.dart';
import '../../../../domain/watch/watch_detail_data.dart';
import '../../../../domain/watch/watch_display_evidence_fact.dart';
import '../../../../domain/watch/watch_display_service_fact.dart';
import '../../../../domain/watch/watch_path_check.dart';
import '../../../../domain/watch/watch_setup_step.dart';
import '../facts/watch_evidence_bundle.dart';
import '../facts/watch_path_fact.dart';

class WatchDetailDataBuilder {
  const WatchDetailDataBuilder();

  WatchDetailData build({
    required WatchEvidenceBundle bundle,
    required StatusLevel level,
    required StatusComponentScore score,
  }) {
    final checks = _pathChecks(bundle.pathFacts);
    final serviceFacts = _serviceFacts(checks);
    final displayEvidence = _displayEvidence(checks);
    return WatchDetailData(
      state: level,
      score: score.value,
      scoreLabel: score.label,
      headline: _headline(level, checks),
      summary: _summary(level, checks),
      latestXdripEntryLabel: _shortValue(
        _fact(checks, 'watch.xdrip_web_service.entries'),
      ),
      xdripWebResponseLabel: _shortValue(
        _fact(checks, 'watch.xdrip_web_service.reachable'),
      ),
      latestWatchEvidenceLabel: _shortValue(
        _fact(checks, 'watch.display.evidence'),
      ),
      signals: _signals(checks),
      pathChecks: checks,
      serviceFacts: serviceFacts,
      displayEvidence: displayEvidence,
      setupSteps: _setupSteps(),
    );
  }

  List<WatchPathCheck> _pathChecks(List<WatchPathFact> facts) {
    return facts
        .map(
          (fact) => WatchPathCheck(
            id: fact.id,
            title: fact.title,
            body: fact.body,
            valueLabel: fact.valueLabel,
            level: fact.level,
            observedAt: fact.observedAt,
            confidence: fact.confidence,
            sourceLabel: fact.sourceLabel,
            trace: fact.trace,
          ),
        )
        .toList(growable: false);
  }

  List<WatchDisplayServiceFact> _serviceFacts(List<WatchPathCheck> checks) {
    final reachable = _fact(checks, 'watch.xdrip_web_service.reachable');
    final entries = _fact(checks, 'watch.xdrip_web_service.entries');
    final bridge = _fact(checks, 'watch.bridge.package');
    final display = _fact(checks, 'watch.display.evidence');
    return [
      _serviceFact(
        'reachable',
        'Reachable',
        reachable,
        'Phone-side xDrip+ display service can answer watch clients.',
      ),
      _serviceFact(
        'entries',
        'Entries',
        entries,
        'Recent glucose values are exposed to display clients.',
      ),
      _serviceFact(
        'bridge',
        'Bridge',
        bridge,
        'A compatible watch bridge package is visible to the probe.',
      ),
      _serviceFact(
        'display',
        'Display',
        display,
        'A watch-side display observation confirms the downstream path.',
      ),
    ];
  }

  WatchDisplayServiceFact _serviceFact(
    String id,
    String label,
    WatchPathCheck? check,
    String body,
  ) {
    final level = check?.level ?? StatusLevel.unknown;
    return WatchDisplayServiceFact(
      id: id,
      label: label,
      value: check == null ? 'Unknown' : _shortValue(check),
      body: body,
      level: level,
      score: check?.confidence.clamp(0, 1) ?? 0,
      trace: check?.trace ?? StatusEvidenceTrace.empty,
    );
  }

  WatchDisplayEvidenceFact _displayEvidence(List<WatchPathCheck> checks) {
    final display = _fact(checks, 'watch.display.evidence');
    if (display == null || display.level == StatusLevel.unknown) {
      return const WatchDisplayEvidenceFact(
        title: 'Watch display evidence is not available',
        body:
            'This optional path has not produced display evidence in the current probe bundle.',
        latestLabel: 'Unknown',
        sourceLabel: 'probe unavailable',
        level: StatusLevel.unknown,
        observedAt: null,
        trace: StatusEvidenceTrace.empty,
      );
    }
    if (display.level == StatusLevel.healthy) {
      return WatchDisplayEvidenceFact(
        title: 'Watch display evidence was observed',
        body:
            'The watch bridge produced evidence that a wearable display path is active.',
        latestLabel: _shortValue(display),
        sourceLabel: display.sourceLabel,
        level: display.level,
        observedAt: display.observedAt,
        trace: display.trace,
      );
    }
    return WatchDisplayEvidenceFact(
      title: 'Watch display needs fresh evidence',
      body:
          'The watch bridge exists, but the latest probe could not confirm a fresh display observation.',
      latestLabel: _shortValue(display),
      sourceLabel: display.sourceLabel,
      level: display.level,
      observedAt: display.observedAt,
      trace: display.trace,
    );
  }

  List<StatusSignalSummary> _signals(List<WatchPathCheck> checks) {
    return checks
        .map(
          (check) => StatusSignalSummary(
            id: check.id,
            label: check.title,
            valueLabel: check.valueLabel,
            level: check.level,
            note: check.sourceLabel,
          ),
        )
        .toList(growable: false);
  }

  List<WatchSetupStep> _setupSteps() {
    return const [
      WatchSetupStep(
        index: '1',
        title: 'Enable xDrip+ Web Service',
        body:
            'Open xDrip+ settings and enable the local Web Service or REST API used by display clients.',
        settingPath: 'Settings > Inter-app settings > Web Service',
      ),
      WatchSetupStep(
        index: '2',
        title: 'Confirm the watch app uses xDrip+',
        body:
            'WatchDrip or another watch companion should read from the phone-side xDrip+ service.',
      ),
      WatchSetupStep(
        index: '3',
        title: 'Wake the watch display once',
        body:
            'Open the watch face or companion screen so a recent display observation can be collected.',
      ),
      WatchSetupStep(
        index: '4',
        title: 'Run Watch Display checks again',
        body:
            'Return to Probe Checklist and run the optional display path after the watch has refreshed.',
      ),
    ];
  }

  String _headline(StatusLevel level, List<WatchPathCheck> checks) {
    if (checks.every((check) => check.level == StatusLevel.healthy)) {
      return 'Watch display path is observable';
    }
    if (checks.every((check) => check.level == StatusLevel.unknown)) {
      return 'Watch display path is not observed';
    }
    if (level == StatusLevel.issue) {
      return 'Watch display path has a blocking issue';
    }
    return 'Watch display path is partially observed';
  }

  String _summary(StatusLevel level, List<WatchPathCheck> checks) {
    final healthy = checks.where((check) => check.level == StatusLevel.healthy);
    if (healthy.isEmpty) {
      return 'This optional watch path has no observable evidence yet. Core CGM flow is not judged by this card.';
    }
    return '${healthy.length} of ${checks.length} watch path checks have observable evidence. This optional path does not change core CGM health.';
  }

  WatchPathCheck? _fact(List<WatchPathCheck> checks, String id) {
    for (final check in checks) {
      if (check.id == id) return check;
    }
    return null;
  }

  String _shortValue(WatchPathCheck? check) {
    if (check == null) return 'Unknown';
    if (check.level == StatusLevel.healthy) return 'Yes';
    if (check.level == StatusLevel.issue) return 'No';
    if (check.level == StatusLevel.watch) return 'Watch';
    return 'Unknown';
  }
}
