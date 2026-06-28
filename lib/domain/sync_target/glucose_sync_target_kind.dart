class GlucoseSyncTargetKind {
  static const selfXdripLocal = GlucoseSyncTargetKind('self.xdrip_local');
  static const selfNightscout = GlucoseSyncTargetKind('self.nightscout');
  static const remoteNightscout = GlucoseSyncTargetKind('remote.nightscout');

  final String code;

  const GlucoseSyncTargetKind(this.code);

  @override
  bool operator ==(Object other) {
    return other is GlucoseSyncTargetKind && other.code == code;
  }

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => code;
}
