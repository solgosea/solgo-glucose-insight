enum AlertSoundLoopMode {
  silent,
  single,
  burst,
  continuous;

  String get code => switch (this) {
    AlertSoundLoopMode.silent => 'silent',
    AlertSoundLoopMode.single => 'single',
    AlertSoundLoopMode.burst => 'burst',
    AlertSoundLoopMode.continuous => 'continuous',
  };

  static AlertSoundLoopMode fromCode(String code) {
    return AlertSoundLoopMode.values.firstWhere(
      (value) => value.code == code,
      orElse: () => AlertSoundLoopMode.single,
    );
  }
}
