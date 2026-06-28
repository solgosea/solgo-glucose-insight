import 'package:smart_xdrip/plugins/explore/status_monitor/domain/hub/facts/aaps_hub_facts.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/hub/facts/cgm_hub_facts.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/hub/facts/juggluco_hub_facts.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/hub/facts/nightscout_hub_facts.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/hub/facts/status_hub_component_facts.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/hub/facts/status_hub_fact_bundle.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/hub/facts/watch_hub_facts.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/hub/facts/xdrip_hub_facts.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/hub/status_hub_enums.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/hub/status_hub_models.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_component_kind.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_level.dart';

StatusHubFactBundle hubTestFacts({
  required DateTime now,
  Duration cgmAge = const Duration(minutes: 4),
  Duration jugglucoAge = const Duration(minutes: 4),
  Duration xdripAge = const Duration(minutes: 3),
  Duration nightscoutAge = const Duration(minutes: 3),
  Duration aapsAge = const Duration(minutes: 3),
  bool jugglucoCompatible = true,
  bool hasJugglucoCompatibleEvidence = true,
  String jugglucoObservedPath = 'xDrip+',
  String jugglucoBroadcastValue = 'OK',
  bool aapsBgSourceObserved = true,
  bool hasAapsBgSourceEvidence = true,
}) {
  final cgm = _component(
    now: now,
    age: cgmAge,
    nodeId: StatusHubNodeId.cgmSensor,
    kind: StatusComponentKind.cgmSensor,
    role: StatusHubNodeRole.source,
    evidenceId: 'sensor_freshness',
    evidenceLabel: 'latest reading',
  );
  final juggluco = _component(
    now: now,
    age: jugglucoAge,
    nodeId: StatusHubNodeId.juggluco,
    kind: StatusComponentKind.juggluco,
    role: StatusHubNodeRole.source,
    evidenceId: 'juggluco_broadcast_freshness',
    evidenceLabel: 'broadcast age',
    evidenceValue: jugglucoBroadcastValue,
    detail: {
      'xdripCompatiblePathObserved': jugglucoCompatible,
      'observedPathLabel': jugglucoObservedPath,
    },
  );
  final xdrip = _component(
    now: now,
    age: xdripAge,
    nodeId: StatusHubNodeId.xdrip,
    kind: StatusComponentKind.xdrip,
    role: StatusHubNodeRole.hub,
    evidenceId: 'completeness_24h',
    evidenceLabel: '24h coverage',
  );
  final nightscout = _component(
    now: now,
    age: nightscoutAge,
    nodeId: StatusHubNodeId.nightscout,
    kind: StatusComponentKind.nightscout,
    role: StatusHubNodeRole.cloud,
    evidenceId: 'server_data_freshness',
    evidenceLabel: 'cloud reading',
  );
  final aaps = _component(
    now: now,
    age: aapsAge,
    nodeId: StatusHubNodeId.aaps,
    kind: StatusComponentKind.aapsLoop,
    role: StatusHubNodeRole.loop,
    evidenceId: 'aaps_sync_freshness',
    evidenceLabel: 'loop age',
    detail: {
      'xdripBgSource': {
        'state': aapsBgSourceObserved ? 'fresh' : 'unknown',
        'level': aapsBgSourceObserved
            ? StatusLevel.healthy.name
            : StatusLevel.unknown.name,
        'stateLabel': aapsBgSourceObserved ? 'xDrip+ observed' : 'Unknown',
      },
    },
  );
  final watch = _component(
    now: now,
    age: xdripAge,
    nodeId: StatusHubNodeId.watch,
    kind: StatusComponentKind.watchDisplay,
    role: StatusHubNodeRole.display,
    evidenceId: 'watch_display',
    evidenceLabel: 'display',
  );

  return StatusHubFactBundle(
    generatedAt: now,
    sourceKind: 'test',
    sourceLabel: 'Test evidence',
    cgm: CgmHubFacts(
      component: cgm,
      latestReadingAgeLabel: _ageLabel(cgmAge),
      sourceModeLabel: 'test',
    ),
    juggluco: JugglucoHubFacts(
      component: juggluco,
      xdripCompatiblePathObserved: jugglucoCompatible,
      hasXdripCompatiblePathEvidence: hasJugglucoCompatibleEvidence,
      receiverLabel: 'com.metaguru.smartxdrip',
      latestLabel: _ageLabel(jugglucoAge),
      xdripAgeLabel: _ageLabel(xdripAge),
      nightscoutAgeLabel: _ageLabel(nightscoutAge),
      observedPathLabel: jugglucoObservedPath,
    ),
    xdrip: XdripHubFacts(
      component: xdrip,
      localBroadcastObserved: true,
      broadcastLevel: StatusLevel.healthy,
      broadcastStateLabel: 'Observed',
      broadcastLatestLabel: _ageLabel(xdripAge),
      receiverPackage: 'com.metaguru.smartxdrip',
      modeLabel: 'test',
    ),
    nightscout: NightscoutHubFacts(
      component: nightscout,
      latestServerReadingLabel: _ageLabel(nightscoutAge),
      medianResponseMs: 42,
      timeoutCount: 0,
    ),
    aaps: AapsHubFacts(
      component: aaps,
      xdripBgSourceObserved: aapsBgSourceObserved,
      hasXdripBgSourceEvidence: hasAapsBgSourceEvidence,
      xdripBgSourceLevel:
          aapsBgSourceObserved ? StatusLevel.healthy : StatusLevel.unknown,
      xdripBgSourceLabel: aapsBgSourceObserved ? 'xDrip+ observed' : 'Unknown',
      latestContextLabel: _ageLabel(aapsAge),
    ),
    watch: WatchHubFacts(
      component: watch,
      bridgePackageObserved: true,
      webServiceReachable: true,
      entriesObserved: true,
      displayObserved: true,
      latestDisplayLabel: _ageLabel(xdripAge),
    ),
  );
}

StatusHubComponentFacts _component({
  required DateTime now,
  required Duration age,
  required StatusHubNodeId nodeId,
  required StatusComponentKind kind,
  required StatusHubNodeRole role,
  required String evidenceId,
  required String evidenceLabel,
  String evidenceValue = 'OK',
  Map<String, Object?> detail = const {},
}) {
  return StatusHubComponentFacts(
    nodeId: nodeId,
    kind: kind,
    label: kind.title,
    role: role,
    state: _state(age),
    latestObservedAt: now.subtract(age),
    age: age,
    confidence: .9,
    availableEvidence: 3,
    expectedEvidence: 3,
    evidence: [
      StatusHubEvidenceRef(
        id: evidenceId,
        label: evidenceLabel,
        valueLabel: evidenceValue,
        level: StatusLevel.healthy,
        source: StatusHubSourceRef.probeEvidence(probeId: evidenceId),
      ),
      StatusHubEvidenceRef(
        id: '${evidenceId}_support',
        label: 'support',
        valueLabel: 'OK',
        level: StatusLevel.healthy,
        source: StatusHubSourceRef.probeEvidence(
          probeId: '${evidenceId}_support',
        ),
      ),
    ],
    detailRoute: '/explore/status/component?kind=${kind.queryValue}',
    detail: detail,
  );
}

StatusHubState _state(Duration age) {
  if (age.inMinutes <= 6) return StatusHubState.fresh;
  if (age.inMinutes <= 15) return StatusHubState.delayed;
  return StatusHubState.stale;
}

String _ageLabel(Duration age) {
  if (age.inMinutes < 1) return 'just now';
  if (age.inHours < 1) return '${age.inMinutes}m';
  if (age.inDays < 1) return '${age.inHours}h';
  return '${age.inDays}d';
}
