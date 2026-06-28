package com.metaguru.smartxdrip.statusmonitor.juggluco

import android.content.Context
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

object JugglucoBroadcastBridge {
    private const val CHANNEL = "com.metaguru.smartxdrip/juggluco_broadcast"

    fun configure(flutterEngine: FlutterEngine, context: Context) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "latest" -> result.success(JugglucoBroadcastSnapshotStore(context).latest())
                    else -> result.notImplemented()
                }
            }
    }
}
