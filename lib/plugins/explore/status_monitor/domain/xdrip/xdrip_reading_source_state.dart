enum XdripReadingSourceState {
  xdripLocal,
  nightscoutFallback,
  none;

  String get label {
    return switch (this) {
      XdripReadingSourceState.xdripLocal => 'xDrip+ Local readings',
      XdripReadingSourceState.nightscoutFallback => 'Nightscout readings',
      XdripReadingSourceState.none => 'No live readings',
    };
  }
}
