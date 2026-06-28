package com.metaguru.smartxdrip.statusmonitor.watch

import android.content.Context
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

object WatchEvidenceBridge {
    private const val CHANNEL = "com.metaguru.smartxdrip/watch_evidence"

    fun configure(flutterEngine: FlutterEngine, context: Context) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "latest" -> result.success(WatchEvidenceSnapshotStore(context).latest())
                    else -> result.notImplemented()
                }
            }
    }
}
