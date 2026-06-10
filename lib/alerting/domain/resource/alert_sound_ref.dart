enum AlertSoundSource {
  asset,
  file,
  silent;

  String get code => switch (this) {
    AlertSoundSource.asset => 'asset',
    AlertSoundSource.file => 'file',
    AlertSoundSource.silent => 'silent',
  };

  static AlertSoundSource fromCode(String code) {
    return AlertSoundSource.values.firstWhere(
      (value) => value.code == code,
      orElse: () => AlertSoundSource.asset,
    );
  }
}

class AlertSoundRef {
  final AlertSoundSource source;
  final String? uri;
  final String displayName;

  const AlertSoundRef({
    required this.source,
    required this.uri,
    required this.displayName,
  });

  const AlertSoundRef.asset({required String uri, required String displayName})
    : this(source: AlertSoundSource.asset, uri: uri, displayName: displayName);

  const AlertSoundRef.file({required String uri, required String displayName})
    : this(source: AlertSoundSource.file, uri: uri, displayName: displayName);

  const AlertSoundRef.silent()
    : source = AlertSoundSource.silent,
      uri = 'silent://none',
      displayName = 'Silent';

  bool get isPlayable => source != AlertSoundSource.silent;

  Map<String, Object?> toJson() => {
    'source': source.code,
    'uri': uri,
    'displayName': displayName,
  };

  static AlertSoundRef fromJson(Map<String, Object?> json) {
    return AlertSoundRef(
      source: AlertSoundSource.fromCode(json['source'] as String? ?? ''),
      uri: json['uri'] as String?,
      displayName: json['displayName'] as String? ?? 'Built-in alert sound',
    );
  }
}
