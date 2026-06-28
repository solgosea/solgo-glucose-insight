enum XdripBroadcastState {
  fresh,
  stale,
  missing,
  invalid,
  unknown;

  String get label {
    return switch (this) {
      XdripBroadcastState.fresh => 'Fresh',
      XdripBroadcastState.stale => 'Stale',
      XdripBroadcastState.missing => 'Missing',
      XdripBroadcastState.invalid => 'Invalid',
      XdripBroadcastState.unknown => 'Unknown',
    };
  }
}
