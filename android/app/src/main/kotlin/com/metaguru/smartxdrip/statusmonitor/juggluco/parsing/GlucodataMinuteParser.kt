package com.metaguru.smartxdrip.statusmonitor.juggluco.parsing

import android.content.Intent
import com.metaguru.smartxdrip.statusmonitor.juggluco.JugglucoBroadcastContract

class GlucodataMinuteParser : JugglucoBroadcastParser {
    override fun canParse(action: String): Boolean {
        return action == JugglucoBroadcastContract.ACTION_GLUCODATA_MINUTE
    }

    override fun parse(intent: Intent, nowMs: Long): JugglucoBroadcastParseResult? {
        val extras = intent.extras
        val timestamp = firstLong(
            extras?.get("glucodata.Minute.Time"),
            extras?.get("timestamp"),
            extras?.get("time"),
            extras?.get("date")
        ) ?: nowMs
        val mgdl = firstDouble(extras?.get("glucodata.Minute.mgdl"))
        val glucose = firstDouble(
            extras?.get("glucodata.Minute.glucose"),
            extras?.get("glucose")
        ) ?: mgdl
        val unit = firstString(extras?.get("unit")) ?: if (mgdl != null) "mg/dL" else null
        return JugglucoBroadcastParseResult(
            atMs = normalizeTimestamp(timestamp),
            glucose = glucose,
            unit = unit,
            path = JugglucoBroadcastContract.PATH_GLUCODATA,
            format = JugglucoBroadcastContract.FORMAT_GLUCODATA_MINUTE,
            message = "Juggluco glucodata broadcast received"
        )
    }
}
