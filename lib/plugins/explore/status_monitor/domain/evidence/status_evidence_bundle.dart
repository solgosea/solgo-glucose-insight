import '../status_source_capabilities.dart';
import '../xdrip/xdrip_broadcast_evidence.dart';
import 'aaps_evidence.dart';
import 'cgm_reading_evidence.dart';
import 'juggluco_broadcast_evidence.dart';
import 'nightscout_evidence.dart';
import 'status_cached_reading_evidence.dart';
import 'status_evidence_selection.dart';
import 'status_evidence_source_kind.dart';
import 'status_live_reading_evidence.dart';
import 'xdrip_local_evidence.dart';

class StatusEvidenceBundle {
  final String subjectId;
  final XdripLocalEvidence xdripLocalEvidence;
  final XdripBroadcastEvidence xdripBroadcastEvidence;
  final NightscoutEvidence nightscoutEvidence;
  final AapsEvidence aapsEvidence;
  final JugglucoBroadcastEvidence jugglucoEvidence;
  final CgmReadingEvidence cachedReadingEvidence;
  final StatusEvidenceSelection selection;

  const StatusEvidenceBundle({
    required this.subjectId,
    required this.xdripLocalEvidence,
    required this.xdripBroadcastEvidence,
    required this.nightscoutEvidence,
    required this.aapsEvidence,
    required this.jugglucoEvidence,
    required this.cachedReadingEvidence,
    required this.selection,
  });

  bool get hasConfiguredSource =>
      xdripLocalEvidence.configured || nightscoutEvidence.configured;

  String? get primarySourceTargetId {
    if (nightscoutEvidence.enabled) return nightscoutEvidence.sourceTargetId;
    if (xdripLocalEvidence.enabled) return xdripLocalEvidence.sourceTargetId;
    return nightscoutEvidence.sourceTargetId ??
        xdripLocalEvidence.sourceTargetId;
  }

  String get primarySourceKind {
    if (nightscoutEvidence.enabled) return 'nightscout';
    if (xdripLocalEvidence.enabled) return 'xdripLocal';
    if (nightscoutEvidence.configured) return 'nightscout';
    if (xdripLocalEvidence.configured) return 'xdripLocal';
    return 'none';
  }

  StatusSourceCapabilities get capabilities {
    if (nightscoutEvidence.enabled) {
      return const StatusSourceCapabilities.nightscout();
    }
    if (xdripLocalEvidence.enabled) {
      return const StatusSourceCapabilities.xdripLocal();
    }
    return const StatusSourceCapabilities.none();
  }

  String get primarySourceLabel {
    if (nightscoutEvidence.enabled) return nightscoutEvidence.sourceLabel;
    if (xdripLocalEvidence.enabled) return xdripLocalEvidence.sourceLabel;
    if (nightscoutEvidence.configured) return nightscoutEvidence.sourceLabel;
    if (xdripLocalEvidence.configured) return xdripLocalEvidence.sourceLabel;
    return 'No source';
  }

  StatusEvidenceBundle copyWith({
    NightscoutEvidence? nightscoutEvidence,
    AapsEvidence? aapsEvidence,
    JugglucoBroadcastEvidence? jugglucoEvidence,
    XdripBroadcastEvidence? xdripBroadcastEvidence,
  }) {
    return StatusEvidenceBundle(
      subjectId: subjectId,
      xdripLocalEvidence: xdripLocalEvidence,
      xdripBroadcastEvidence:
          xdripBroadcastEvidence ?? this.xdripBroadcastEvidence,
      nightscoutEvidence: nightscoutEvidence ?? this.nightscoutEvidence,
      aapsEvidence: aapsEvidence ?? this.aapsEvidence,
      jugglucoEvidence: jugglucoEvidence ?? this.jugglucoEvidence,
      cachedReadingEvidence: cachedReadingEvidence,
      selection: selection,
    );
  }

  static StatusLiveReadingEvidence selectCgmLiveReadings({
    required XdripLocalEvidence xdrip,
    required NightscoutEvidence nightscout,
  }) {
    if (xdrip.hasReadings) {
      return StatusLiveReadingEvidence(
        sourceKind: StatusEvidenceSourceKind.xdripLocal,
        sourceLabel: '${xdrip.sourceLabel} readings',
        readings: xdrip.readings,
        generatedAt: xdrip.generatedAt,
      );
    }
    if (nightscout.hasReadings) {
      return StatusLiveReadingEvidence(
        sourceKind: StatusEvidenceSourceKind.nightscout,
        sourceLabel: '${nightscout.sourceLabel} readings',
        readings: nightscout.readings,
        generatedAt: nightscout.generatedAt,
      );
    }
    return const StatusLiveReadingEvidence.none(
      failureLabel: 'No live CGM readings are available from active sources.',
    );
  }

  static StatusCachedReadingEvidence selectCgmHistoryReadings({
    required CgmReadingEvidence cached,
  }) {
    if (cached.available) {
      return StatusCachedReadingEvidence(
        sourceLabel: cached.sourceLabel,
        readings: cached.readings,
        generatedAt: cached.generatedAt,
      );
    }
    return StatusCachedReadingEvidence.none(
      failureLabel:
          cached.failureLabel ?? 'No cached CGM readings are available.',
    );
  }

  static StatusLiveReadingEvidence selectXdripLiveReadings({
    required XdripLocalEvidence xdrip,
    required NightscoutEvidence nightscout,
  }) {
    if (xdrip.hasReadings) {
      return StatusLiveReadingEvidence(
        sourceKind: StatusEvidenceSourceKind.xdripLocal,
        sourceLabel: '${xdrip.sourceLabel} readings',
        readings: xdrip.readings,
        generatedAt: xdrip.generatedAt,
      );
    }
    if (nightscout.hasReadings) {
      return StatusLiveReadingEvidence(
        sourceKind: StatusEvidenceSourceKind.nightscout,
        sourceLabel: '${nightscout.sourceLabel} readings',
        readings: nightscout.readings,
        generatedAt: nightscout.generatedAt,
      );
    }
    return const StatusLiveReadingEvidence.none(
      failureLabel:
          'No live readings are available for xDrip+ data flow checks.',
    );
  }
}
