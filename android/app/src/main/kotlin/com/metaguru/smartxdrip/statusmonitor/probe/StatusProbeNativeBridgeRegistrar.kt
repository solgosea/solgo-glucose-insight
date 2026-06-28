package com.metaguru.smartxdrip.statusmonitor.probe

import android.content.Context
import com.metaguru.smartxdrip.statusmonitor.probe.device.DeviceProbeBridge
import com.metaguru.smartxdrip.statusmonitor.probe.packageinfo.PackageProbeBridge
import io.flutter.embedding.engine.FlutterEngine

object StatusProbeNativeBridgeRegistrar {
    fun configure(flutterEngine: FlutterEngine, context: Context) {
        PackageProbeBridge.configure(flutterEngine, context)
        DeviceProbeBridge.configure(flutterEngine, context)
    }
}
