package com.metaguru.smartxdrip.statusmonitor.xdrip

import android.content.Context
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

object XdripBroadcastBridge {
    private const val CHANNEL = "com.metaguru.smartxdrip/xdrip_broadcast"

    fun configure(flutterEngine: FlutterEngine, context: Context) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "latest" -> result.success(XdripBroadcastSnapshotStore(context).latest())
                    else -> result.notImplemented()
                }
            }
    }
}
