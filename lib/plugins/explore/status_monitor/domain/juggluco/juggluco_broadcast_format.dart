enum JugglucoBroadcastFormat {
  glucodataMinute,
  xdripCompatible,
  unknown;

  String get label {
    return switch (this) {
      JugglucoBroadcastFormat.glucodataMinute => 'glucodata',
      JugglucoBroadcastFormat.xdripCompatible => 'xDrip compatible',
      JugglucoBroadcastFormat.unknown => 'Unknown',
    };
  }

  static JugglucoBroadcastFormat fromName(String? value) {
    return switch (value) {
      'glucodataMinute' || 'glucodata' => glucodataMinute,
      'xdripCompatible' || 'xdrip' => xdripCompatible,
      _ => unknown,
    };
  }
}
