package com.metaguru.smartxdrip.statusmonitor.probe.device

data class DeviceProbeResult(
    val networkConnected: Boolean,
    val internetValidated: Boolean,
    val networkType: String,
    val bluetoothSupported: Boolean,
    val bluetoothEnabled: Boolean,
    val bluetoothPermissionGranted: Boolean,
    val notificationPermissionGranted: Boolean,
    val batteryOptimizationIgnored: Boolean,
    val powerSaveMode: Boolean,
    val checkedAtMs: Long,
    val error: String? = null,
) {
    fun toMap(): Map<String, Any?> = mapOf(
        DeviceProbeContract.FIELD_NETWORK_CONNECTED to networkConnected,
        DeviceProbeContract.FIELD_INTERNET_VALIDATED to internetValidated,
        DeviceProbeContract.FIELD_NETWORK_TYPE to networkType,
        DeviceProbeContract.FIELD_BLUETOOTH_SUPPORTED to bluetoothSupported,
        DeviceProbeContract.FIELD_BLUETOOTH_ENABLED to bluetoothEnabled,
        DeviceProbeContract.FIELD_BLUETOOTH_PERMISSION_GRANTED to bluetoothPermissionGranted,
        DeviceProbeContract.FIELD_NOTIFICATION_PERMISSION_GRANTED to notificationPermissionGranted,
        DeviceProbeContract.FIELD_BATTERY_OPTIMIZATION_IGNORED to batteryOptimizationIgnored,
        DeviceProbeContract.FIELD_POWER_SAVE_MODE to powerSaveMode,
        DeviceProbeContract.FIELD_CHECKED_AT_MS to checkedAtMs,
        DeviceProbeContract.FIELD_ERROR to error,
    )
}
