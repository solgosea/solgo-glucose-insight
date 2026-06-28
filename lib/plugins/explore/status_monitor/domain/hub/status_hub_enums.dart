enum StatusHubState {
  fresh,
  delayed,
  stale,
  unavailable,
  limited,
  notChecked,
  unknown;

  bool get needsAttention {
    return switch (this) {
      StatusHubState.delayed ||
      StatusHubState.stale ||
      StatusHubState.unavailable ||
      StatusHubState.limited =>
        true,
      _ => false,
    };
  }
}

enum StatusHubNodeRole {
  source,
  collector,
  hub,
  cloud,
  loop,
  display,
  observer,
}

enum StatusHubNodeId {
  cgmSensor('cgm_sensor'),
  juggluco('juggluco'),
  xdrip('xdrip'),
  nightscout('nightscout'),
  aaps('aaps'),
  watch('watch'),
  solgoObserver('solgo_observer');

  final String value;
  const StatusHubNodeId(this.value);
}

enum StatusHubConnectionKind {
  cgmToXdrip,
  jugglucoToXdrip,
  xdripToNightscout,
  xdripToAaps,
  xdripToWatch,
}

enum StatusHubConnectionId {
  cgmToXdrip('cgm_to_xdrip'),
  jugglucoToXdrip('juggluco_to_xdrip'),
  xdripToNightscout('xdrip_to_nightscout'),
  xdripToAaps('xdrip_to_aaps'),
  xdripToWatch('xdrip_to_watch');

  final String value;
  const StatusHubConnectionId(this.value);
}

enum StatusHubTopologyKind {
  xdripCollector,
  jugglucoToXdrip,
  xdripToNightscout,
  xdripToAaps,
  nightscoutOnly,
  unknown,
}

enum StatusHubFocusReason {
  upstreamStale,
  targetDelayedVsSource,
  handoffDelayed,
  downstreamLimited,
  setupRequired,
  evidenceLimited,
  allClear,
}

enum StatusHubPathDiagnosisReason {
  upstreamAligned,
  sourceStale,
  hubDelayed,
  handoffAligned,
  receiverNotConfigured,
  compatiblePathMissing,
  uploadAligned,
  uploadDelayed,
  cloudUnavailable,
  localObservationStale,
  bothSidesStale,
  bgSourceObserved,
  bgSourceMissing,
  loopContextLimited,
  displayOnly,
  insufficientEvidence,
}
