package com.metaguru.smartxdrip.statusmonitor.juggluco

import android.content.Context
import com.metaguru.smartxdrip.statusmonitor.juggluco.parsing.JugglucoBroadcastParseResult
import org.json.JSONArray
import org.json.JSONObject

class JugglucoBroadcastSnapshotStore(private val context: Context) {
    private val prefs = context.getSharedPreferences("juggluco_broadcast_status", Context.MODE_PRIVATE)

    fun save(payload: JugglucoBroadcastParseResult) {
        val timeline = timeline().toMutableList()
        timeline.add(mapOf("atMs" to payload.atMs, "state" to "fresh", "path" to payload.path))
        val trimmed = timeline.sortedByDescending { it["atMs"] as Long }.take(96)
        val paths = latestByPath().toMutableMap()
        paths[payload.path] = mapOf(
            "path" to payload.path,
            "atMs" to payload.atMs,
            "glucose" to payload.glucose,
            "unit" to payload.unit,
            "format" to payload.format,
            "message" to payload.message
        )
        prefs.edit()
            .putBoolean("receiverConfigured", true)
            .putBoolean("broadcastObserved", true)
            .putLong("latestBroadcastAtMs", payload.atMs)
            .putString("broadcastFormat", payload.format)
            .putString("latestPath", payload.path)
            .putString("unit", payload.unit)
            .putString("sanitizedMessage", payload.message)
            .putString("timeline", encodeTimeline(trimmed))
            .putString("latestByPath", encodeLatestByPath(paths.values.toList()))
            .apply()
        if (payload.glucose != null) {
            prefs.edit().putFloat("latestGlucose", payload.glucose.toFloat()).apply()
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
            "broadcastFormat" to prefs.getString("broadcastFormat", "unknown"),
            "latestPath" to prefs.getString("latestPath", null),
            "latestByPath" to latestByPath().values.toList(),
            "sanitizedMessage" to prefs.getString("sanitizedMessage", null),
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
            mapOf(
                "atMs" to item.optLong("atMs"),
                "state" to item.optString("state", "unknown"),
                "path" to item.optString("path", null)
            )
        }
    }

    private fun encodeTimeline(items: List<Map<String, Any?>>): String {
        val array = JSONArray()
        for (item in items) {
            array.put(
                JSONObject()
                    .put("atMs", item["atMs"])
                    .put("state", item["state"])
                    .put("path", item["path"])
            )
        }
        return array.toString()
    }

    private fun latestByPath(): Map<String, Map<String, Any?>> {
        val raw = prefs.getString("latestByPath", "[]") ?: "[]"
        val array = JSONArray(raw)
        return (0 until array.length()).mapNotNull { index ->
            val item = array.optJSONObject(index) ?: return@mapNotNull null
            val path = item.optString("path", null) ?: return@mapNotNull null
            path to mapOf(
                "path" to path,
                "atMs" to item.optLong("atMs"),
                "glucose" to if (item.has("glucose") && !item.isNull("glucose")) item.optDouble("glucose") else null,
                "unit" to item.optString("unit", null),
                "format" to item.optString("format", "unknown"),
                "message" to item.optString("message", null)
            )
        }.toMap()
    }

    private fun encodeLatestByPath(items: List<Map<String, Any?>>): String {
        val array = JSONArray()
        for (item in items) {
            array.put(
                JSONObject()
                    .put("path", item["path"])
                    .put("atMs", item["atMs"])
                    .put("glucose", item["glucose"])
                    .put("unit", item["unit"])
                    .put("format", item["format"])
                    .put("message", item["message"])
            )
        }
        return array.toString()
    }
}
