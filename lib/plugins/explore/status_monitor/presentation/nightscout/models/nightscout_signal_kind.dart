enum NightscoutSignalKind {
  reachability,
  responseTime,
  deviceStatus,
}

extension NightscoutSignalKindLabel on NightscoutSignalKind {
  String get title {
    return switch (this) {
      NightscoutSignalKind.reachability => 'Reachability',
      NightscoutSignalKind.responseTime => 'Response Time',
      NightscoutSignalKind.deviceStatus => 'Device Status',
    };
  }
}
