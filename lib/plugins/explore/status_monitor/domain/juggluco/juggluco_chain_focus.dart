enum JugglucoChainFocus {
  localPathFlowing,
  jugglucoToXdrip,
  xdripToNightscout,
  sourceSide,
  setupRequired,
  unknown;

  String get label {
    return switch (this) {
      JugglucoChainFocus.localPathFlowing => 'Local path flowing',
      JugglucoChainFocus.jugglucoToXdrip => 'Juggluco -> xDrip+ handoff',
      JugglucoChainFocus.xdripToNightscout =>
        'xDrip+ -> Nightscout upload path',
      JugglucoChainFocus.sourceSide => 'Libre / Juggluco / phone source side',
      JugglucoChainFocus.setupRequired => 'Enable Juggluco broadcast',
      JugglucoChainFocus.unknown => 'More evidence needed',
    };
  }
}
