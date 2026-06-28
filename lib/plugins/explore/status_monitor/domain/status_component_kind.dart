enum StatusComponentKind {
  cgmSensor,
  juggluco,
  xdrip,
  nightscout,
  aapsLoop,
  watchDisplay;

  String get queryValue {
    return switch (this) {
      StatusComponentKind.cgmSensor => 'cgm',
      StatusComponentKind.juggluco => 'juggluco',
      StatusComponentKind.xdrip => 'xdrip',
      StatusComponentKind.nightscout => 'nightscout',
      StatusComponentKind.aapsLoop => 'aaps',
      StatusComponentKind.watchDisplay => 'watch',
    };
  }

  String get title {
    return switch (this) {
      StatusComponentKind.cgmSensor => 'CGM Sensor',
      StatusComponentKind.juggluco => 'Juggluco',
      StatusComponentKind.xdrip => 'xDrip+',
      StatusComponentKind.nightscout => 'Nightscout',
      StatusComponentKind.aapsLoop => 'AAPS Loop',
      StatusComponentKind.watchDisplay => 'Watch display',
    };
  }

  String get role {
    return switch (this) {
      StatusComponentKind.cgmSensor => 'Sensor signal',
      StatusComponentKind.juggluco => 'Primary broadcast path',
      StatusComponentKind.xdrip => 'Phone uploader',
      StatusComponentKind.nightscout => 'Cloud server',
      StatusComponentKind.aapsLoop => 'Loop context',
      StatusComponentKind.watchDisplay => 'Display bridge',
    };
  }

  static StatusComponentKind fromQuery(String? value) {
    return switch (value) {
      'cgm' => StatusComponentKind.cgmSensor,
      'juggluco' => StatusComponentKind.juggluco,
      'xdrip' => StatusComponentKind.xdrip,
      'nightscout' => StatusComponentKind.nightscout,
      'aaps' => StatusComponentKind.aapsLoop,
      'watch' => StatusComponentKind.watchDisplay,
      _ => StatusComponentKind.nightscout,
    };
  }
}
