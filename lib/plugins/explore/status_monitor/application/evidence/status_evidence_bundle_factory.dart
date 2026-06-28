import '../../domain/evidence/aaps_evidence.dart';
import '../../domain/evidence/cgm_reading_evidence.dart';
import '../../domain/evidence/juggluco_broadcast_evidence.dart';
import '../../domain/evidence/nightscout_evidence.dart';
import '../../domain/evidence/status_evidence_bundle.dart';
import '../../domain/evidence/status_evidence_selection.dart';
import '../../domain/evidence/xdrip_local_evidence.dart';
import '../../domain/xdrip/xdrip_broadcast_evidence.dart';

class StatusEvidenceBundleFactory {
  const StatusEvidenceBundleFactory();

  StatusEvidenceBundle build({
    required String subjectId,
    required DateTime now,
    XdripLocalEvidence? xdripLocal,
    XdripBroadcastEvidence? xdripBroadcast,
    NightscoutEvidence? nightscout,
    AapsEvidence? aaps,
    JugglucoBroadcastEvidence? juggluco,
    CgmReadingEvidence? cached,
  }) {
    final resolvedXdrip = xdripLocal ?? const XdripLocalEvidence.none();
    final resolvedNightscout = nightscout ?? const NightscoutEvidence.none();
    final resolvedCached = cached ?? const CgmReadingEvidence.none();
    return StatusEvidenceBundle(
      subjectId: subjectId,
      xdripLocalEvidence: resolvedXdrip,
      xdripBroadcastEvidence:
          xdripBroadcast ?? XdripBroadcastEvidence.none(generatedAt: now),
      nightscoutEvidence: resolvedNightscout,
      aapsEvidence: aaps ?? _emptyAaps(now),
      jugglucoEvidence:
          juggluco ?? JugglucoBroadcastEvidence.none(generatedAt: now),
      cachedReadingEvidence: resolvedCached,
      selection: StatusEvidenceSelection(
        cgmLiveReadings: StatusEvidenceBundle.selectCgmLiveReadings(
          xdrip: resolvedXdrip,
          nightscout: resolvedNightscout,
        ),
        cgmHistoryReadings: StatusEvidenceBundle.selectCgmHistoryReadings(
          cached: resolvedCached,
        ),
        xdripLiveReadings: StatusEvidenceBundle.selectXdripLiveReadings(
          xdrip: resolvedXdrip,
          nightscout: resolvedNightscout,
        ),
      ),
    );
  }

  AapsEvidence _emptyAaps(DateTime now) {
    return AapsEvidence(
      configured: false,
      nightscoutReachable: false,
      deviceStatusSamples: const [],
      generatedAt: now,
      sanitizedFailureLabel: 'No Nightscout AAPS context is available.',
    );
  }
}
