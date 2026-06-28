package com.metaguru.smartxdrip.statusmonitor.juggluco.parsing

import android.content.Intent
import com.metaguru.smartxdrip.statusmonitor.juggluco.JugglucoBroadcastContract

class PatchedLibreBroadcastParser : JugglucoBroadcastParser {
    override fun canParse(action: String): Boolean {
        return action == JugglucoBroadcastContract.ACTION_PATCHED_LIBRE_GLUCOSE
    }

    override fun parse(intent: Intent, nowMs: Long): JugglucoBroadcastParseResult? {
        val extras = intent.extras
        val timestamp = firstLong(extras?.get("timestamp")) ?: nowMs
        val glucose = firstDouble(extras?.get("glucose"))
        return JugglucoBroadcastParseResult(
            atMs = normalizeTimestamp(timestamp),
            glucose = glucose,
            unit = if (glucose != null && glucose > 40) "mg/dL" else null,
            path = JugglucoBroadcastContract.PATH_PATCHED_LIBRE,
            format = JugglucoBroadcastContract.FORMAT_XDRIP_COMPATIBLE,
            message = "Patched Libre compatible broadcast received"
        )
    }
}
