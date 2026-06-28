package com.metaguru.smartxdrip.statusmonitor.watch

import android.content.Context
import android.content.Intent
import org.json.JSONArray
import org.json.JSONObject

class WatchEvidenceSnapshotStore(private val context: Context) {
    private val prefs = context.getSharedPreferences("watch_evidence_status", Context.MODE_PRIVATE)

    fun save(intent: Intent) {
        val atMs = intent.getLongExtra("timestamp", System.currentTimeMillis())
        val bridgeName = intent.getStringExtra("bridgeName") ?: "watch"
        val displayObserved = intent.getBooleanExtra("displayObserved", true)
        val timeline = timeline().toMutableList()
        timeline.add(mapOf("atMs" to atMs, "bridgeName" to bridgeName))
        val trimmed = timeline.sortedByDescending { it["atMs"] as Long }.take(96)

        prefs.edit()
            .putBoolean("evidenceObserved", true)
            .putLong("latestEvidenceAtMs", atMs)
            .putString("bridgeName", bridgeName)
            .putBoolean("displayObserved", displayObserved)
            .putString("timeline", encodeTimeline(trimmed))
            .apply()
    }

    fun latest(): Map<String, Any?> {
        return mapOf(
            "receiverConfigured" to true,
            "evidenceObserved" to prefs.getBoolean("evidenceObserved", false),
            "latestEvidenceAtMs" to prefs.getLong("latestEvidenceAtMs", 0L),
            "bridgeName" to prefs.getString("bridgeName", null),
            "displayObserved" to prefs.getBoolean("displayObserved", false),
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
                "bridgeName" to item.optString("bridgeName", null)
            )
        }
    }

    private fun encodeTimeline(items: List<Map<String, Any?>>): String {
        val array = JSONArray()
        for (item in items) {
            array.put(
                JSONObject()
                    .put("atMs", item["atMs"])
                    .put("bridgeName", item["bridgeName"])
            )
        }
        return array.toString()
    }
}
