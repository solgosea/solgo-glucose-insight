package com.metaguru.smartxdrip.platform

import com.metaguru.smartxdrip.floating.FloatingSurfaceBridge
import com.metaguru.smartxdrip.glance.GlanceWidgetBridge
import com.metaguru.smartxdrip.statusmonitor.StatusMonitorWidgetBridge
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

object NativeBridgeRegistry {
    fun configure(flutterEngine: FlutterEngine, activity: FlutterActivity) {
        GlanceWidgetBridge.configure(flutterEngine, activity)
        StatusMonitorWidgetBridge.configure(flutterEngine, activity)
        FloatingSurfaceBridge.configure(flutterEngine, activity)
        CoreDeviceIdentityBridge.configure(flutterEngine, activity)
        AppLifecycleBridge.configure(flutterEngine, activity)
    }
}
