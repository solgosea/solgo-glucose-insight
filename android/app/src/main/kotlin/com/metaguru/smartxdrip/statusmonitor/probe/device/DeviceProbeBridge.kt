package com.metaguru.smartxdrip.statusmonitor.probe.device

import android.content.Context
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

object DeviceProbeBridge {
    fun configure(flutterEngine: FlutterEngine, context: Context) {
        val source = DeviceProbeSource(context)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, DeviceProbeContract.CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    DeviceProbeContract.METHOD_QUERY -> result.success(source.query().toMap())
                    else -> result.notImplemented()
                }
            }
    }
}
