enum CgmSensorSignalKind {
  session,
  variability,
  jumps,
  flatPeriod,
}

extension CgmSensorSignalKindLabel on CgmSensorSignalKind {
  String get title {
    return switch (this) {
      CgmSensorSignalKind.session => 'Sensor Session',
      CgmSensorSignalKind.variability => 'Variability',
      CgmSensorSignalKind.jumps => 'Sudden Jumps',
      CgmSensorSignalKind.flatPeriod => 'Flat Periods',
    };
  }
}
