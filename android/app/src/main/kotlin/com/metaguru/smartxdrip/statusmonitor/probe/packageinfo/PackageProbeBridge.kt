package com.metaguru.smartxdrip.statusmonitor.probe.packageinfo

import android.content.Context
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

object PackageProbeBridge {
    fun configure(flutterEngine: FlutterEngine, context: Context) {
        val source = PackageProbeSource(context)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PackageProbeContract.CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    PackageProbeContract.METHOD_QUERY -> {
                        val packageName = call.argument<String>(
                            PackageProbeContract.ARG_PACKAGE_NAME,
                        ).orEmpty()
                        result.success(source.query(packageName).toMap())
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
