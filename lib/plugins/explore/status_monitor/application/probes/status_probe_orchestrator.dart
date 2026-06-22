import 'package:smart_xdrip/data/local/glucose_database.dart';

import '../../domain/evidence/status_evidence_bundle.dart';
import '../../domain/evidence/status_evidence_selection.dart';
import '../evidence/aaps_evidence_parser.dart';
import 'cached_reading_probe_strategy.dart';
import 'nightscout_probe_strategy.dart';
import 'status_probe_plan.dart';
import 'xdrip_local_probe_strategy.dart';

class StatusProbeOrchestrator {
  final GlucoseDatabase database;
  final AapsEvidenceParser aapsEvidenceParser;

  const StatusProbeOrchestrator({
    required this.database,
    this.aapsEvidenceParser = const AapsEvidenceParser(),
  });

  Future<StatusEvidenceBundle> run(
    StatusProbePlan plan, {
    required DateTime now,
  }) async {
    final xdripFuture = XdripLocalProbeStrategy(
      resolution: plan.xdripLocal,
      now: now,
    ).probe();
    final nightscoutFuture = NightscoutProbeStrategy(
      resolution: plan.nightscout,
      now: now,
    ).probe();
    final cachedFuture = CachedReadingProbeStrategy(
      database: database,
      subjectId: plan.subjectId,
      now: now,
    ).probe();

    final xdrip = await xdripFuture;
    final nightscout = await nightscoutFuture;
    final cached = await cachedFuture;

    final selectedCgmLive = StatusEvidenceBundle.selectCgmLiveReadings(
      xdrip: xdrip,
      nightscout: nightscout,
    );
    final selectedCgmHistory = StatusEvidenceBundle.selectCgmHistoryReadings(
      cached: cached,
    );
    final selectedXdripLive = StatusEvidenceBundle.selectXdripLiveReadings(
      xdrip: xdrip,
      nightscout: nightscout,
    );
    final aaps = aapsEvidenceParser.parse(
      nightscout: nightscout,
      now: now,
    );

    return StatusEvidenceBundle(
      subjectId: plan.subjectId,
      xdripLocalEvidence: xdrip,
      nightscoutEvidence: nightscout,
      aapsEvidence: aaps,
      cachedReadingEvidence: cached,
      selection: StatusEvidenceSelection(
        cgmLiveReadings: selectedCgmLive,
        cgmHistoryReadings: selectedCgmHistory,
        xdripLiveReadings: selectedXdripLive,
      ),
    );
  }
}
