package com.metaguru.smartxdrip.statusmonitor.xdrip

import android.content.Context
import com.metaguru.smartxdrip.statusmonitor.xdrip.parsing.XdripBroadcastParseResult
import org.json.JSONArray
import org.json.JSONObject

class XdripBroadcastSnapshotStore(private val context: Context) {
    private val prefs = context.getSharedPreferences("xdrip_broadcast_status", Context.MODE_PRIVATE)

    fun save(payload: XdripBroadcastParseResult) {
        val timeline = timeline().toMutableList()
        timeline.add(mapOf("atMs" to payload.atMs))
        val trimmed = timeline.sortedByDescending { it["atMs"] as Long }.take(96)
        prefs.edit()
            .putBoolean("receiverConfigured", true)
            .putBoolean("broadcastObserved", true)
            .putLong("latestBroadcastAtMs", payload.atMs)
            .putString("unit", payload.unit)
            .putString("slopeName", payload.slopeName)
            .putString("sourceAction", payload.sourceAction)
            .putString("timeline", encodeTimeline(trimmed))
            .apply()
        if (payload.glucose != null) {
            prefs.edit().putFloat("latestGlucose", payload.glucose.toFloat()).apply()
        }
        if (payload.slope != null) {
            prefs.edit().putFloat("slope", payload.slope.toFloat()).apply()
        }
    }

    fun latest(): Map<String, Any?> {
        val observed = prefs.getBoolean("broadcastObserved", false)
        return mapOf(
            "receiverConfigured" to true,
            "broadcastObserved" to observed,
            "latestBroadcastAtMs" to prefs.getLong("latestBroadcastAtMs", 0L),
            "latestGlucose" to if (prefs.contains("latestGlucose")) prefs.getFloat("latestGlucose", 0f).toDouble() else null,
            "unit" to prefs.getString("unit", null),
            "slopeName" to prefs.getString("slopeName", null),
            "slope" to if (prefs.contains("slope")) prefs.getFloat("slope", 0f).toDouble() else null,
            "sourceAction" to prefs.getString("sourceAction", XdripBroadcastContract.ACTION_BG_ESTIMATE),
            "timeline" to timeline()
        )
    }

    fun clear() {
        prefs.edit().clear().commit()
    }

    private fun timeline(): List<Map<String, Any?>> {
        val raw = prefs.getString("timeline", "[]") ?: "[]"
        val array = JSONArray(raw)
        return (0 until array.length()).mapNotNull { index ->
            val item = array.optJSONObject(index) ?: return@mapNotNull null
            mapOf("atMs" to item.optLong("atMs"))
        }
    }

    private fun encodeTimeline(items: List<Map<String, Any?>>): String {
        val array = JSONArray()
        for (item in items) {
            array.put(JSONObject().put("atMs", item["atMs"]))
        }
        return array.toString()
    }
}
