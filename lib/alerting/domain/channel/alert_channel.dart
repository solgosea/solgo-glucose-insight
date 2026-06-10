enum AlertChannel {
  inApp,
  localNotification,
  sound,
  vibration;

  String get code => switch (this) {
    AlertChannel.inApp => 'in_app',
    AlertChannel.localNotification => 'local_notification',
    AlertChannel.sound => 'sound',
    AlertChannel.vibration => 'vibration',
  };

  static AlertChannel fromCode(String code) {
    return AlertChannel.values.firstWhere(
      (value) => value.code == code,
      orElse: () => AlertChannel.inApp,
    );
  }
}
