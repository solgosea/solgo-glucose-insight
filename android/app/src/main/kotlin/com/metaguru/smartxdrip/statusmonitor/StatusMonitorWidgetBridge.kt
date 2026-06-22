package com.metaguru.smartxdrip.statusmonitor

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

object StatusMonitorWidgetBridge {
    private const val CHANNEL = "com.metaguru.smartxdrip/status_monitor_widget"

    fun configure(flutterEngine: FlutterEngine, context: Context) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "publishSnapshot" -> {
                        @Suppress("UNCHECKED_CAST")
                        StatusMonitorWidgetSnapshotStore(context).save(
                            call.arguments as? Map<String, Any?> ?: emptyMap()
                        )
                        updateAllWidgets(context)
                        result.success(true)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun updateAllWidgets(context: Context) {
        val manager = AppWidgetManager.getInstance(context)
        val providers = listOf(
            StatusMonitorCompactWidgetProvider::class.java,
            StatusMonitorFlowWidgetProvider::class.java,
            StatusMonitorIssueWidgetProvider::class.java,
            StatusMonitorDetailedWidgetProvider::class.java
        )
        for (provider in providers) {
            val component = ComponentName(context, provider)
            val ids = manager.getAppWidgetIds(component)
            val instance = provider.getDeclaredConstructor().newInstance()
            instance.onUpdate(context, manager, ids)
        }
    }
}
