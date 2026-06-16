package com.metaguru.smartxdrip.glance.floating

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.provider.Settings
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

object FloatingGlanceBridge {
    private const val CHANNEL = "com.metaguru.smartxdrip/floating_glance"

    fun configure(flutterEngine: FlutterEngine, context: Context) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "hasOverlayPermission" -> result.success(Settings.canDrawOverlays(context))
                    "requestOverlayPermission" -> {
                        val intent = Intent(
                            Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                            Uri.parse("package:${context.packageName}")
                        ).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        context.startActivity(intent)
                        result.success(true)
                    }
                    "start", "update" -> {
                        @Suppress("UNCHECKED_CAST")
                        val args = call.arguments as? Map<String, Any?> ?: emptyMap()
                        FloatingGlanceSnapshotStore(context).save(args)
                        val intent = Intent(context, FloatingGlanceOverlayService::class.java)
                        context.startService(intent)
                        FloatingGlanceOverlayService.activeService?.render()
                        result.success(true)
                    }
                    "stop" -> {
                        context.stopService(Intent(context, FloatingGlanceOverlayService::class.java))
                        result.success(true)
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
