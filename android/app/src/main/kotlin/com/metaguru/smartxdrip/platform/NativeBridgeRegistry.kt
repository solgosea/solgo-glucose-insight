package com.metaguru.smartxdrip.platform

import com.metaguru.smartxdrip.floating.FloatingSurfaceBridge
import com.metaguru.smartxdrip.glance.GlanceWidgetBridge
import com.metaguru.smartxdrip.statusmonitor.StatusMonitorWidgetBridge
import com.metaguru.smartxdrip.statusmonitor.aaps.AapsEvidenceBridge
import com.metaguru.smartxdrip.statusmonitor.juggluco.JugglucoBroadcastBridge
import com.metaguru.smartxdrip.statusmonitor.probe.StatusProbeNativeBridgeRegistrar
import com.metaguru.smartxdrip.statusmonitor.watch.WatchEvidenceBridge
import com.metaguru.smartxdrip.statusmonitor.xdrip.XdripBroadcastBridge
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

object NativeBridgeRegistry {
    fun configure(flutterEngine: FlutterEngine, activity: FlutterActivity) {
        GlanceWidgetBridge.configure(flutterEngine, activity)
        StatusMonitorWidgetBridge.configure(flutterEngine, activity)
        JugglucoBroadcastBridge.configure(flutterEngine, activity)
        XdripBroadcastBridge.configure(flutterEngine, activity)
        AapsEvidenceBridge.configure(flutterEngine, activity)
        WatchEvidenceBridge.configure(flutterEngine, activity)
        StatusProbeNativeBridgeRegistrar.configure(flutterEngine, activity)
        FloatingSurfaceBridge.configure(flutterEngine, activity)
        CoreDeviceIdentityBridge.configure(flutterEngine, activity)
        AppLifecycleBridge.configure(flutterEngine, activity)
    }
}
