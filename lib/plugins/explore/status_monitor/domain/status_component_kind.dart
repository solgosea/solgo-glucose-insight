enum StatusComponentKind {
  cgmSensor,
  xdrip,
  nightscout,
  aapsLoop;

  String get queryValue {
    return switch (this) {
      StatusComponentKind.cgmSensor => 'cgm',
      StatusComponentKind.xdrip => 'xdrip',
      StatusComponentKind.nightscout => 'nightscout',
      StatusComponentKind.aapsLoop => 'aaps',
    };
  }

  String get title {
    return switch (this) {
      StatusComponentKind.cgmSensor => 'CGM Sensor',
      StatusComponentKind.xdrip => 'xDrip+',
      StatusComponentKind.nightscout => 'Nightscout',
      StatusComponentKind.aapsLoop => 'AAPS Loop',
    };
  }

  String get role {
    return switch (this) {
      StatusComponentKind.cgmSensor => 'Sensor signal',
      StatusComponentKind.xdrip => 'Phone uploader',
      StatusComponentKind.nightscout => 'Cloud server',
      StatusComponentKind.aapsLoop => 'Loop context',
    };
  }

  static StatusComponentKind fromQuery(String? value) {
    return switch (value) {
      'cgm' => StatusComponentKind.cgmSensor,
      'xdrip' => StatusComponentKind.xdrip,
      'nightscout' => StatusComponentKind.nightscout,
      'aaps' => StatusComponentKind.aapsLoop,
      _ => StatusComponentKind.nightscout,
    };
  }
}
