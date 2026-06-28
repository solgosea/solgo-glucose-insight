package com.metaguru.smartxdrip.statusmonitor.probe.device

import android.Manifest
import android.app.NotificationManager
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.content.Context
import android.content.pm.PackageManager
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.os.Build
import android.os.PowerManager
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat

class DeviceProbeSource(private val context: Context) {
    private companion object {
        // Android keeps BLE scanning available in a hidden STATE_BLE_ON mode on
        // some vendor ROMs. The public BluetoothAdapter.isEnabled flag remains
        // false there, but CGM broadcast/probe paths can still use BLE evidence.
        const val BLUETOOTH_STATE_BLE_ON = 15
    }

    fun query(): DeviceProbeResult {
        val checkedAtMs = System.currentTimeMillis()
        return try {
            val connectivity =
                context.getSystemService(Context.CONNECTIVITY_SERVICE) as? ConnectivityManager
            val activeNetwork = connectivity?.activeNetwork
            val capabilities = activeNetwork?.let { connectivity.getNetworkCapabilities(it) }
            val networkConnected = capabilities != null &&
                (capabilities.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) ||
                    capabilities.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR) ||
                    capabilities.hasTransport(NetworkCapabilities.TRANSPORT_ETHERNET) ||
                    capabilities.hasTransport(NetworkCapabilities.TRANSPORT_VPN))
            val networkType = when {
                capabilities?.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) == true -> "wifi"
                capabilities?.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR) == true -> "cellular"
                capabilities?.hasTransport(NetworkCapabilities.TRANSPORT_ETHERNET) == true -> "ethernet"
                capabilities?.hasTransport(NetworkCapabilities.TRANSPORT_VPN) == true -> "vpn"
                else -> "none"
            }
            val internetValidated =
                capabilities?.hasCapability(NetworkCapabilities.NET_CAPABILITY_VALIDATED) == true

            val bluetoothManager =
                context.getSystemService(Context.BLUETOOTH_SERVICE) as? BluetoothManager
            val adapter: BluetoothAdapter? = bluetoothManager?.adapter
            val bluetoothSupported = adapter != null
            val bluetoothPermissionGranted = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                ContextCompat.checkSelfPermission(
                    context,
                    Manifest.permission.BLUETOOTH_CONNECT,
                ) == PackageManager.PERMISSION_GRANTED
            } else {
                true
            }
            val bluetoothLeState = runCatching {
                adapter?.javaClass?.getMethod("getLeState")?.invoke(adapter) as? Int
            }.getOrNull()
            val bluetoothEnabled = if (bluetoothPermissionGranted) {
                adapter?.isEnabled == true ||
                    adapter?.state == BLUETOOTH_STATE_BLE_ON ||
                    bluetoothLeState == BLUETOOTH_STATE_BLE_ON
            } else {
                false
            }

            val notificationPermissionGranted =
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    ContextCompat.checkSelfPermission(
                        context,
                        Manifest.permission.POST_NOTIFICATIONS,
                    ) == PackageManager.PERMISSION_GRANTED
                } else {
                    NotificationManagerCompat.from(context).areNotificationsEnabled()
                }

            val powerManager =
                context.getSystemService(Context.POWER_SERVICE) as? PowerManager
            val batteryOptimizationIgnored =
                powerManager?.isIgnoringBatteryOptimizations(context.packageName) == true
            val powerSaveMode = powerManager?.isPowerSaveMode == true

            DeviceProbeResult(
                networkConnected = networkConnected,
                internetValidated = internetValidated,
                networkType = networkType,
                bluetoothSupported = bluetoothSupported,
                bluetoothEnabled = bluetoothEnabled,
                bluetoothPermissionGranted = bluetoothPermissionGranted,
                notificationPermissionGranted = notificationPermissionGranted,
                batteryOptimizationIgnored = batteryOptimizationIgnored,
                powerSaveMode = powerSaveMode,
                checkedAtMs = checkedAtMs,
            )
        } catch (error: Throwable) {
            DeviceProbeResult(
                networkConnected = false,
                internetValidated = false,
                networkType = "unknown",
                bluetoothSupported = false,
                bluetoothEnabled = false,
                bluetoothPermissionGranted = false,
                notificationPermissionGranted = false,
                batteryOptimizationIgnored = false,
                powerSaveMode = false,
                checkedAtMs = checkedAtMs,
                error = error.message ?: error.javaClass.simpleName,
            )
        }
    }
}
