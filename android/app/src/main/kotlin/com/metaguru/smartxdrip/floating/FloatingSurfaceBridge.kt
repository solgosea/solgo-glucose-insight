package com.metaguru.smartxdrip.floating

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.provider.Settings
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

object FloatingSurfaceBridge {
    private const val CHANNEL = "com.metaguru.smartxdrip/floating_surface"
    private var lastPayloadSignature: String? = null

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
                    "update" -> {
                        @Suppress("UNCHECKED_CAST")
                        val args = call.arguments as? Map<String, Any?> ?: emptyMap()
                        val signature = args.toString()
                        if (signature == lastPayloadSignature) {
                            result.success(true)
                            return@setMethodCallHandler
                        }
                        lastPayloadSignature = signature
                        FloatingSurfaceSnapshotStore(context).save(args)
                        context.startService(Intent(context, FloatingSurfaceOverlayService::class.java))
                        FloatingSurfaceOverlayService.activeService?.render()
                        result.success(true)
                    }
                    "stop" -> {
                        lastPayloadSignature = null
                        context.stopService(Intent(context, FloatingSurfaceOverlayService::class.java))
                        result.success(true)
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
