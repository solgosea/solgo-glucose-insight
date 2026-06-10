class AlertVibrationPattern {
  final String key;
  final String displayName;
  final List<int> pattern;
  final List<int> intensities;

  const AlertVibrationPattern({
    required this.key,
    required this.displayName,
    required this.pattern,
    this.intensities = const [],
  });

  const AlertVibrationPattern.criticalRepeat()
    : key = 'critical_repeat',
      displayName = 'Critical repeat',
      pattern = const [0, 700, 250, 700, 250, 900],
      intensities = const [0, 255, 0, 255, 0, 255];

  const AlertVibrationPattern.shortWarning()
    : key = 'short_warning',
      displayName = 'Short warning',
      pattern = const [0, 250, 150, 250],
      intensities = const [0, 180, 0, 180];

  Map<String, Object?> toJson() => {
    'key': key,
    'displayName': displayName,
    'pattern': pattern,
    'intensities': intensities,
  };

  static AlertVibrationPattern fromJson(Map<String, Object?> json) {
    final pattern =
        (json['pattern'] as List?)
            ?.map((value) => (value as num).round())
            .toList() ??
        const [0, 700, 250, 700];
    final intensities =
        (json['intensities'] as List?)
            ?.map((value) => (value as num).round())
            .toList() ??
        const <int>[];
    return AlertVibrationPattern(
      key: json['key'] as String? ?? 'critical_repeat',
      displayName: json['displayName'] as String? ?? 'Critical repeat',
      pattern: pattern,
      intensities: intensities,
    );
  }
}
