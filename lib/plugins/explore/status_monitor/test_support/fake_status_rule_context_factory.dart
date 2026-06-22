import 'package:smart_xdrip/domain/entities/glucose_reading.dart';

import '../domain/analysis/status_analysis_context.dart';
import '../domain/evidence/cgm_reading_evidence.dart';
import '../domain/evidence/nightscout_evidence.dart';
import '../domain/evidence/status_evidence_bundle.dart';
import '../domain/evidence/status_evidence_selection.dart';
import '../domain/evidence/xdrip_local_evidence.dart';
import '../application/evidence/aaps_evidence_parser.dart';

class FakeStatusRuleContextFactory {
  const FakeStatusRuleContextFactory();

  StatusAnalysisContext build({
    DateTime? now,
    List<GlucoseReading>? cgmHistoryReadings,
    List<GlucoseReading>? xdripReadings,
    List<GlucoseReading>? nightscoutReadings,
    XdripLocalEvidence? xdrip,
    NightscoutEvidence? nightscout,
  }) {
    final timestamp = now ?? DateTime.utc(2026, 6, 12, 6);
    final xdripEvidence = xdrip ??
        XdripLocalEvidence(
          configured: xdripReadings != null,
          enabled: xdripReadings != null,
          sourceLabel: 'xDrip+ Local',
          generatedAt: timestamp,
          readings: xdripReadings ?? const [],
        );
    final nightscoutEvidence = nightscout ??
        NightscoutEvidence(
          configured: nightscoutReadings != null,
          enabled: nightscoutReadings != null,
          sourceLabel: 'Nightscout',
          generatedAt: timestamp,
          readings: nightscoutReadings ?? const [],
        );
    final cachedEvidence = CgmReadingEvidence(
      sourceLabel: 'Cached 24h local readings',
      readings: cgmHistoryReadings ?? const [],
      generatedAt: timestamp,
    );
    final selectedCgmLive = StatusEvidenceBundle.selectCgmLiveReadings(
      xdrip: xdripEvidence,
      nightscout: nightscoutEvidence,
    );
    final selectedCgmHistory = StatusEvidenceBundle.selectCgmHistoryReadings(
      cached: cachedEvidence,
    );
    final selectedXdripLive = StatusEvidenceBundle.selectXdripLiveReadings(
      xdrip: xdripEvidence,
      nightscout: nightscoutEvidence,
    );
    final aapsEvidence = const AapsEvidenceParser().parse(
      nightscout: nightscoutEvidence,
      now: timestamp,
    );
    return StatusAnalysisContext(
      now: timestamp,
      evidence: StatusEvidenceBundle(
        subjectId: 'test',
        xdripLocalEvidence: xdripEvidence,
        nightscoutEvidence: nightscoutEvidence,
        aapsEvidence: aapsEvidence,
        cachedReadingEvidence: cachedEvidence,
        selection: StatusEvidenceSelection(
          cgmLiveReadings: selectedCgmLive,
          cgmHistoryReadings: selectedCgmHistory,
          xdripLiveReadings: selectedXdripLive,
        ),
      ),
    );
  }
}
