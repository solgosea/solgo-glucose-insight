package com.metaguru.smartxdrip.statusmonitor

import android.content.Context
import org.json.JSONArray
import org.json.JSONObject

data class StatusMonitorWidgetComponent(
    val title: String,
    val level: String,
    val levelLabel: String,
    val detail: String,
    val scoreLabel: String
)

data class StatusMonitorWidgetSnapshot(
    val template: String,
    val headline: String,
    val summary: String,
    val sourceLabel: String,
    val updatedLabel: String,
    val freshnessLabel: String,
    val notificationText: String,
    val lockScreenText: String,
    val primaryIssueLabel: String,
    val level: String,
    val scoreLabel: String,
    val hasConfiguredSource: Boolean,
    val isStale: Boolean,
    val privateMode: Boolean,
    val sensorToUploader: String,
    val uploaderToServer: String,
    val components: List<StatusMonitorWidgetComponent>
)

class StatusMonitorWidgetSnapshotStore(private val context: Context) {
    private val prefs = context.getSharedPreferences("status_monitor_widget", Context.MODE_PRIVATE)

    fun save(payload: Map<String, Any?>) {
        prefs.edit().putString("snapshot", JSONObject(payload).toString()).apply()
    }

    fun load(): StatusMonitorWidgetSnapshot {
        val json = prefs.getString("snapshot", null)
        if (json.isNullOrBlank()) return emptySnapshot()
        val obj = JSONObject(json)
        val components = mutableListOf<StatusMonitorWidgetComponent>()
        val rawComponents = obj.optJSONArray("components") ?: JSONArray()
        for (i in 0 until rawComponents.length()) {
            val item = rawComponents.optJSONObject(i) ?: continue
            components.add(
                StatusMonitorWidgetComponent(
                    title = item.optString("title", "--"),
                    level = item.optString("level", "unknown"),
                    levelLabel = item.optString("levelLabel", "Unknown"),
                    detail = item.optString("detail", ""),
                    scoreLabel = item.optString("scoreLabel", "--")
                )
            )
        }
        return StatusMonitorWidgetSnapshot(
            template = obj.optString("template", "flow"),
            headline = obj.optString("headline", "Status unavailable"),
            summary = obj.optString("summary", "Open SolgoInsight to refresh status"),
            sourceLabel = obj.optString("sourceLabel", "No source"),
            updatedLabel = obj.optString("updatedLabel", "Not updated"),
            freshnessLabel = obj.optString("freshnessLabel", ""),
            notificationText = obj.optString("notificationText", "Status unavailable"),
            lockScreenText = obj.optString("lockScreenText", "Status unavailable"),
            primaryIssueLabel = obj.optString("primaryIssueLabel", "Status"),
            level = obj.optString("level", "unknown"),
            scoreLabel = obj.optString("scoreLabel", "--"),
            hasConfiguredSource = obj.optBoolean("hasConfiguredSource", false),
            isStale = obj.optBoolean("isStale", false),
            privateMode = obj.optBoolean("privateMode", false),
            sensorToUploader = obj.optString("sensorToUploader", "unknown"),
            uploaderToServer = obj.optString("uploaderToServer", "unknown"),
            components = components
        )
    }

    private fun emptySnapshot(): StatusMonitorWidgetSnapshot {
        return StatusMonitorWidgetSnapshot(
            template = "flow",
            headline = "Status unavailable",
            summary = "Open SolgoInsight to refresh status",
            sourceLabel = "No source",
            updatedLabel = "Not updated",
            freshnessLabel = "",
            notificationText = "Status unavailable",
            lockScreenText = "Status unavailable",
            primaryIssueLabel = "Status",
            level = "unknown",
            scoreLabel = "--",
            hasConfiguredSource = false,
            isStale = false,
            privateMode = false,
            sensorToUploader = "unknown",
            uploaderToServer = "unknown",
            components = listOf(
                StatusMonitorWidgetComponent("CGM Sensor", "unknown", "Unknown", "", "--"),
                StatusMonitorWidgetComponent("xDrip+", "unknown", "Unknown", "", "--"),
                StatusMonitorWidgetComponent("Nightscout", "unknown", "Unknown", "", "--")
            )
        )
    }
}
