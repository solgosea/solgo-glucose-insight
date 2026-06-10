package com.metaguru.smartxdrip

import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.metaguru.smartxdrip/device_identity"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "androidId" -> result.success(
                    Settings.Secure.getString(contentResolver, Settings.Secure.ANDROID_ID)
                )
                else -> result.notImplemented()
            }
        }
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.metaguru.smartxdrip/app_lifecycle"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "moveTaskToBack" -> {
                    moveTaskToBack(true)
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }
}
