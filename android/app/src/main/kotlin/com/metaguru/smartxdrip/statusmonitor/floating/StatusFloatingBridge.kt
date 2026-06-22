package com.metaguru.smartxdrip.statusmonitor.floating

import android.content.Context
import android.content.Intent
import android.provider.Settings
import com.metaguru.smartxdrip.platform.OverlayPermissionIntentLauncher
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

object StatusFloatingBridge {
    private const val CHANNEL = "com.metaguru.smartxdrip/status_monitor_floating"

    fun configure(flutterEngine: FlutterEngine, context: Context) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "hasOverlayPermission" -> result.success(Settings.canDrawOverlays(context))
                    "requestOverlayPermission" -> {
                        OverlayPermissionIntentLauncher.openAppOverlaySettings(context)
                        result.success(true)
                    }
                    "start", "update" -> {
                        @Suppress("UNCHECKED_CAST")
                        val args = call.arguments as? Map<String, Any?> ?: emptyMap()
                        StatusFloatingSnapshotStore(context).save(args)
                        val intent = Intent(context, StatusFloatingOverlayService::class.java)
                        context.startService(intent)
                        StatusFloatingOverlayService.activeService?.render()
                        result.success(true)
                    }
                    "stop" -> {
                        context.stopService(Intent(context, StatusFloatingOverlayService::class.java))
                        result.success(true)
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
