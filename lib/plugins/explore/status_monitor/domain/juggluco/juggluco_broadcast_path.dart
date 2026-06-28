enum JugglucoBroadcastPath {
  glucodata,
  xdripLocal,
  patchedLibre,
  eversense,
  unknown;

  bool get isXdripCompatible {
    return switch (this) {
      JugglucoBroadcastPath.patchedLibre ||
      JugglucoBroadcastPath.eversense =>
        true,
      JugglucoBroadcastPath.glucodata ||
      JugglucoBroadcastPath.xdripLocal ||
      JugglucoBroadcastPath.unknown =>
        false,
    };
  }

  String get label {
    return switch (this) {
      JugglucoBroadcastPath.glucodata => 'Glucodata direct',
      JugglucoBroadcastPath.xdripLocal => 'xDrip local broadcast',
      JugglucoBroadcastPath.patchedLibre => 'Patched Libre -> xDrip+',
      JugglucoBroadcastPath.eversense => '640G/EverSense -> xDrip+',
      JugglucoBroadcastPath.unknown => 'Unknown',
    };
  }

  static JugglucoBroadcastPath fromName(String? value) {
    return switch (value) {
      'glucodata' => JugglucoBroadcastPath.glucodata,
      'xdripLocal' => JugglucoBroadcastPath.xdripLocal,
      'patchedLibre' => JugglucoBroadcastPath.patchedLibre,
      'eversense' => JugglucoBroadcastPath.eversense,
      _ => JugglucoBroadcastPath.unknown,
    };
  }
}
