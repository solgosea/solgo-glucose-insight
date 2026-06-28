package com.metaguru.smartxdrip.statusmonitor.aaps

import android.content.Context
import android.content.Intent
import org.json.JSONArray
import org.json.JSONObject

class AapsEvidenceSnapshotStore(private val context: Context) {
    private val prefs = context.getSharedPreferences("aaps_evidence_status", Context.MODE_PRIVATE)

    fun save(intent: Intent) {
        val atMs = intent.getLongExtra("timestamp", System.currentTimeMillis())
        val bgSource = intent.getStringExtra("bgSource") ?: "xdrip"
        val devicestatusObserved = intent.getBooleanExtra("devicestatusObserved", false)
        val loopContextObserved = intent.getBooleanExtra("loopContextObserved", false)
        val loopState = intent.getStringExtra("loopState")
        val timeline = timeline().toMutableList()
        timeline.add(mapOf("atMs" to atMs, "bgSource" to bgSource))
        val trimmed = timeline.sortedByDescending { it["atMs"] as Long }.take(96)

        prefs.edit()
            .putBoolean("evidenceObserved", true)
            .putLong("latestEvidenceAtMs", atMs)
            .putString("bgSource", bgSource)
            .putBoolean("devicestatusObserved", devicestatusObserved)
            .putBoolean("loopContextObserved", loopContextObserved)
            .putString("loopState", loopState)
            .putString("timeline", encodeTimeline(trimmed))
            .apply()
    }

    fun latest(): Map<String, Any?> {
        return mapOf(
            "receiverConfigured" to true,
            "evidenceObserved" to prefs.getBoolean("evidenceObserved", false),
            "latestEvidenceAtMs" to prefs.getLong("latestEvidenceAtMs", 0L),
            "bgSource" to prefs.getString("bgSource", null),
            "devicestatusObserved" to prefs.getBoolean("devicestatusObserved", false),
            "loopContextObserved" to prefs.getBoolean("loopContextObserved", false),
            "loopState" to prefs.getString("loopState", null),
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
                "bgSource" to item.optString("bgSource", null)
            )
        }
    }

    private fun encodeTimeline(items: List<Map<String, Any?>>): String {
        val array = JSONArray()
        for (item in items) {
            array.put(
                JSONObject()
                    .put("atMs", item["atMs"])
                    .put("bgSource", item["bgSource"])
            )
        }
        return array.toString()
    }
}
