enum XdripSignalKind {
  freshness,
  completeness,
  latency,
  battery,
}

extension XdripSignalKindLabel on XdripSignalKind {
  String get title {
    return switch (this) {
      XdripSignalKind.freshness => 'Freshness',
      XdripSignalKind.completeness => '24h Completeness',
      XdripSignalKind.latency => 'Upload Latency',
      XdripSignalKind.battery => 'Uploader Battery',
    };
  }
}
