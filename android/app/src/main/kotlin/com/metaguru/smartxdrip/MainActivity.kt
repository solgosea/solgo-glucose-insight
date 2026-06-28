package com.metaguru.smartxdrip

import android.content.Intent
import android.util.Base64
import android.util.Log
import com.metaguru.smartxdrip.platform.NativeBridgeRegistry
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var debugRouteChannel: MethodChannel? = null
    private var pendingDebugRoute: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        NativeBridgeRegistry.configure(flutterEngine, this)
        debugRouteChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.metaguru.smartxdrip/debug_route",
        ).also { channel ->
            channel.setMethodCallHandler { call, result ->
                when (call.method) {
                    "consumePendingRoute" -> {
                        val route = pendingDebugRoute
                        pendingDebugRoute = null
                        result.success(route)
                    }
                    else -> result.notImplemented()
                }
            }
        }
        handleDebugRouteIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        handleDebugRouteIntent(intent)
    }

    private fun handleDebugRouteIntent(intent: Intent?) {
        if (intent?.action != "com.metaguru.smartxdrip.DEBUG_OPEN_ROUTE") return
        val route = decodeDebugRoute(intent) ?: return
        Log.i("SolgoInsightDebugRoute", "open route=$route")
        pendingDebugRoute = route
        debugRouteChannel?.invokeMethod(
            "openRoute",
            mapOf("route" to route),
            object : MethodChannel.Result {
                override fun success(result: Any?) {
                    Log.i("SolgoInsightDebugRoute", "openRoute delivered")
                }

                override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                    Log.w(
                        "SolgoInsightDebugRoute",
                        "openRoute error code=$errorCode message=$errorMessage",
                    )
                }

                override fun notImplemented() {
                    Log.w("SolgoInsightDebugRoute", "openRoute not implemented")
                }
            },
        )
    }

    private fun decodeDebugRoute(intent: Intent): String? {
        val routeBase64 = intent.getStringExtra("routeBase64")
        if (!routeBase64.isNullOrBlank()) {
            return try {
                String(Base64.decode(routeBase64, Base64.NO_WRAP), Charsets.UTF_8)
            } catch (_: IllegalArgumentException) {
                null
            }
        }
        return intent.getStringExtra("route")
    }
}
