package com.metaguru.smartxdrip.statusmonitor.xdrip.parsing

import android.content.Intent
import com.metaguru.smartxdrip.statusmonitor.xdrip.XdripBroadcastContract

class BgEstimateBroadcastParser : XdripBroadcastParser {
    override fun supports(action: String?): Boolean {
        return action == XdripBroadcastContract.ACTION_BG_ESTIMATE
    }

    override fun parse(intent: Intent, nowMs: Long): XdripBroadcastParseResult? {
        if (!supports(intent.action)) return null
        val glucose = firstDouble(
            intent,
            "glucose",
            "bg",
            "bgEstimate",
            "estimate",
            "sgv"
        )
        val timestamp = firstLong(
            intent,
            "timestamp",
            "time",
            "date",
            "dateString"
        ) ?: nowMs
        return XdripBroadcastParseResult(
            atMs = normalizeTimestamp(timestamp, nowMs),
            glucose = glucose,
            unit = intent.getStringExtra("units") ?: intent.getStringExtra("unit") ?: "mg/dL",
            slopeName = intent.getStringExtra("slopeName") ?: intent.getStringExtra("direction"),
            slope = firstDouble(intent, "slope", "slopeValue"),
            sourceAction = intent.action ?: XdripBroadcastContract.ACTION_BG_ESTIMATE
        )
    }

    private fun firstDouble(intent: Intent, vararg names: String): Double? {
        for (name in names) {
            val extras = intent.extras ?: continue
            if (!extras.containsKey(name)) continue
            val value = extras.get(name)
            when (value) {
                is Number -> return value.toDouble()
                is String -> value.toDoubleOrNull()?.let { return it }
            }
        }
        return null
    }

    private fun firstLong(intent: Intent, vararg names: String): Long? {
        for (name in names) {
            val extras = intent.extras ?: continue
            if (!extras.containsKey(name)) continue
            val value = extras.get(name)
            when (value) {
                is Number -> return value.toLong()
                is String -> value.toLongOrNull()?.let { return it }
            }
        }
        return null
    }

    private fun normalizeTimestamp(value: Long, nowMs: Long): Long {
        if (value <= 0) return nowMs
        return if (value < 10_000_000_000L) value * 1000 else value
    }
}
