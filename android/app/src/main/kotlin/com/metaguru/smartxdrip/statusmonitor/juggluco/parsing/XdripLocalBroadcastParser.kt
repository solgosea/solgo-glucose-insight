package com.metaguru.smartxdrip.statusmonitor.juggluco.parsing

import android.content.Intent
import com.metaguru.smartxdrip.statusmonitor.juggluco.JugglucoBroadcastContract

class XdripLocalBroadcastParser : JugglucoBroadcastParser {
    override fun canParse(action: String): Boolean {
        return action == JugglucoBroadcastContract.ACTION_XDRIP_BG_ESTIMATE
    }

    override fun parse(intent: Intent, nowMs: Long): JugglucoBroadcastParseResult? {
        val extras = intent.extras
        val timestamp = firstLong(
            extras?.get("com.eveningoutpost.dexdrip.Extras.Time"),
            extras?.get("timestamp"),
            extras?.get("time"),
            extras?.get("date")
        ) ?: nowMs
        val glucose = firstDouble(
            extras?.get("com.eveningoutpost.dexdrip.Extras.BgEstimate"),
            extras?.get("glucose"),
            extras?.get("mgdl"),
            extras?.get("sgv"),
            extras?.get("bg")
        )
        return JugglucoBroadcastParseResult(
            atMs = normalizeTimestamp(timestamp),
            glucose = glucose,
            unit = if (glucose != null && glucose > 40) "mg/dL" else null,
            path = JugglucoBroadcastContract.PATH_XDRIP_LOCAL,
            format = JugglucoBroadcastContract.FORMAT_XDRIP_COMPATIBLE,
            message = "xDrip local broadcast received"
        )
    }
}
