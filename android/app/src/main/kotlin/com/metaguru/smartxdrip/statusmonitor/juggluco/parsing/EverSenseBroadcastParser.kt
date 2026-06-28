package com.metaguru.smartxdrip.statusmonitor.juggluco.parsing

import android.content.Intent
import com.metaguru.smartxdrip.statusmonitor.juggluco.JugglucoBroadcastContract
import org.json.JSONArray

class EverSenseBroadcastParser : JugglucoBroadcastParser {
    override fun canParse(action: String): Boolean {
        return action == JugglucoBroadcastContract.ACTION_NS_EMULATOR
    }

    override fun parse(intent: Intent, nowMs: Long): JugglucoBroadcastParseResult? {
        val extras = intent.extras
        if (extras?.getString("collection") != "entries") return null
        val raw = extras.getString("data") ?: return null
        val item = JSONArray(raw).optJSONObject(0) ?: return null
        val timestamp = item.optLong("date", nowMs)
        val glucose = item.optDouble("sgv", Double.NaN).takeUnless { it.isNaN() }
        return JugglucoBroadcastParseResult(
            atMs = normalizeTimestamp(timestamp),
            glucose = glucose,
            unit = if (glucose != null && glucose > 40) "mg/dL" else null,
            path = JugglucoBroadcastContract.PATH_EVERSENSE,
            format = JugglucoBroadcastContract.FORMAT_XDRIP_COMPATIBLE,
            message = "640G/EverSense compatible broadcast received"
        )
    }
}
