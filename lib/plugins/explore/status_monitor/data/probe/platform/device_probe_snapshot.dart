class DeviceProbeSnapshot {
  final bool networkConnected;
  final bool internetValidated;
  final String networkType;
  final bool bluetoothSupported;
  final bool bluetoothEnabled;
  final bool bluetoothPermissionGranted;
  final bool notificationPermissionGranted;
  final bool batteryOptimizationIgnored;
  final bool powerSaveMode;
  final DateTime checkedAt;
  final String? error;

  const DeviceProbeSnapshot({
    required this.networkConnected,
    required this.internetValidated,
    required this.networkType,
    required this.bluetoothSupported,
    required this.bluetoothEnabled,
    required this.bluetoothPermissionGranted,
    required this.notificationPermissionGranted,
    required this.batteryOptimizationIgnored,
    required this.powerSaveMode,
    required this.checkedAt,
    this.error,
  });

  bool get hasError => error != null && error!.isNotEmpty;

  factory DeviceProbeSnapshot.fromMap(Map<Object?, Object?> map) {
    final checkedAtMs = map['checkedAtMs'];
    return DeviceProbeSnapshot(
      networkConnected: map['networkConnected'] == true,
      internetValidated: map['internetValidated'] == true,
      networkType: map['networkType']?.toString() ?? 'unknown',
      bluetoothSupported: map['bluetoothSupported'] == true,
      bluetoothEnabled: map['bluetoothEnabled'] == true,
      bluetoothPermissionGranted: map['bluetoothPermissionGranted'] == true,
      notificationPermissionGranted:
          map['notificationPermissionGranted'] == true,
      batteryOptimizationIgnored: map['batteryOptimizationIgnored'] == true,
      powerSaveMode: map['powerSaveMode'] == true,
      checkedAt: DateTime.fromMillisecondsSinceEpoch(
        checkedAtMs is int
            ? checkedAtMs
            : int.tryParse(checkedAtMs?.toString() ?? '') ?? 0,
      ),
      error: map['error']?.toString(),
    );
  }

  factory DeviceProbeSnapshot.unsupported(Object error) {
    return DeviceProbeSnapshot(
      networkConnected: false,
      internetValidated: false,
      networkType: 'unknown',
      bluetoothSupported: false,
      bluetoothEnabled: false,
      bluetoothPermissionGranted: false,
      notificationPermissionGranted: false,
      batteryOptimizationIgnored: false,
      powerSaveMode: false,
      checkedAt: DateTime.now(),
      error: error.toString(),
    );
  }
}
