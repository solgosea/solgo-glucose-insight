package com.metaguru.smartxdrip.statusmonitor.aaps

import android.content.Context
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

object AapsEvidenceBridge {
    private const val CHANNEL = "com.metaguru.smartxdrip/aaps_evidence"

    fun configure(flutterEngine: FlutterEngine, context: Context) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "latest" -> result.success(AapsEvidenceSnapshotStore(context).latest())
                    else -> result.notImplemented()
                }
            }
    }
}
