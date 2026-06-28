package com.metaguru.smartxdrip.statusmonitor.probe.packageinfo

import android.content.Context
import android.content.pm.PackageManager
import android.os.Build

class PackageProbeSource(private val context: Context) {
    fun query(packageName: String): PackageProbeResult {
        val checkedAtMs = System.currentTimeMillis()
        if (packageName.isBlank()) {
            return PackageProbeResult(
                packageName = packageName,
                visible = false,
                installed = false,
                versionName = null,
                versionCode = null,
                checkedAtMs = checkedAtMs,
                error = "empty package name",
            )
        }

        return try {
            val packageInfo = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                context.packageManager.getPackageInfo(
                    packageName,
                    PackageManager.PackageInfoFlags.of(0),
                )
            } else {
                @Suppress("DEPRECATION")
                context.packageManager.getPackageInfo(packageName, 0)
            }
            val versionCode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                packageInfo.longVersionCode
            } else {
                @Suppress("DEPRECATION")
                packageInfo.versionCode.toLong()
            }
            PackageProbeResult(
                packageName = packageName,
                visible = true,
                installed = true,
                versionName = packageInfo.versionName,
                versionCode = versionCode,
                checkedAtMs = checkedAtMs,
            )
        } catch (_: PackageManager.NameNotFoundException) {
            PackageProbeResult(
                packageName = packageName,
                visible = false,
                installed = false,
                versionName = null,
                versionCode = null,
                checkedAtMs = checkedAtMs,
            )
        } catch (error: Throwable) {
            PackageProbeResult(
                packageName = packageName,
                visible = false,
                installed = false,
                versionName = null,
                versionCode = null,
                checkedAtMs = checkedAtMs,
                error = error.message ?: error.javaClass.simpleName,
            )
        }
    }
}
