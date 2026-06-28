package com.metaguru.smartxdrip.statusmonitor.probe.device

object DeviceProbeContract {
    const val CHANNEL = "com.metaguru.smartxdrip/status_probe_device"
    const val METHOD_QUERY = "query"

    const val FIELD_NETWORK_CONNECTED = "networkConnected"
    const val FIELD_INTERNET_VALIDATED = "internetValidated"
    const val FIELD_NETWORK_TYPE = "networkType"
    const val FIELD_BLUETOOTH_SUPPORTED = "bluetoothSupported"
    const val FIELD_BLUETOOTH_ENABLED = "bluetoothEnabled"
    const val FIELD_BLUETOOTH_PERMISSION_GRANTED = "bluetoothPermissionGranted"
    const val FIELD_NOTIFICATION_PERMISSION_GRANTED = "notificationPermissionGranted"
    const val FIELD_BATTERY_OPTIMIZATION_IGNORED = "batteryOptimizationIgnored"
    const val FIELD_POWER_SAVE_MODE = "powerSaveMode"
    const val FIELD_CHECKED_AT_MS = "checkedAtMs"
    const val FIELD_ERROR = "error"
}
