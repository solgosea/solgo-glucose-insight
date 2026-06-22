package com.metaguru.smartxdrip.statusmonitor.floating

import android.content.Context
import org.json.JSONArray

data class StatusFloatingComponent(
    val label: String,
    val level: String,
    val glyph: String
)

data class StatusFloatingSnapshot(
    val mode: String,
    val x: Int,
    val y: Int,
    val collapsed: Boolean,
    val headline: String,
    val freshnessLabel: String,
    val level: String,
    val hasConfiguredSource: Boolean,
    val isStale: Boolean,
    val components: List<StatusFloatingComponent>
)

class StatusFloatingSnapshotStore(private val context: Context) {
    private val prefs = context.getSharedPreferences("status_monitor_floating", Context.MODE_PRIVATE)

    fun save(arguments: Map<String, Any?>) {
        prefs.edit()
            .putString("mode", arguments["mode"] as? String ?: "enabled")
            .putInt("x", (arguments["x"] as? Number)?.toInt() ?: prefs.getInt("x", 24))
            .putInt("y", (arguments["y"] as? Number)?.toInt() ?: prefs.getInt("y", 160))
            .putBoolean("collapsed", arguments["collapsed"] as? Boolean ?: prefs.getBoolean("collapsed", false))
            .putString("headline", arguments["headline"] as? String ?: "Status unavailable")
            .putString("freshnessLabel", arguments["freshnessLabel"] as? String ?: "")
            .putString("level", arguments["level"] as? String ?: "unknown")
            .putBoolean("hasConfiguredSource", arguments["hasConfiguredSource"] as? Boolean ?: false)
            .putBoolean("isStale", arguments["isStale"] as? Boolean ?: true)
            .putString("components", JSONArray(arguments["components"] as? List<*> ?: emptyList<Any>()).toString())
            .apply()
    }

    fun savePosition(x: Int, y: Int) {
        prefs.edit().putInt("x", x).putInt("y", y).apply()
    }

    fun load(): StatusFloatingSnapshot {
        val components = mutableListOf<StatusFloatingComponent>()
        val raw = JSONArray(prefs.getString("components", "[]") ?: "[]")
        for (i in 0 until raw.length()) {
            val item = raw.optJSONObject(i) ?: continue
            components.add(
                StatusFloatingComponent(
                    label = item.optString("label", "--"),
                    level = item.optString("level", "unknown"),
                    glyph = item.optString("glyph", "○")
                )
            )
        }
        val fallback = listOf(
            StatusFloatingComponent("Sensor", "unknown", "○"),
            StatusFloatingComponent("Uploader", "unknown", "○"),
            StatusFloatingComponent("Nightscout", "unknown", "○")
        )
        return StatusFloatingSnapshot(
            mode = prefs.getString("mode", "enabled") ?: "enabled",
            x = prefs.getInt("x", 24),
            y = prefs.getInt("y", 160),
            collapsed = prefs.getBoolean("collapsed", false),
            headline = prefs.getString("headline", "Status unavailable") ?: "Status unavailable",
            freshnessLabel = prefs.getString("freshnessLabel", "") ?: "",
            level = prefs.getString("level", "unknown") ?: "unknown",
            hasConfiguredSource = prefs.getBoolean("hasConfiguredSource", false),
            isStale = prefs.getBoolean("isStale", true),
            components = if (components.isEmpty()) fallback else components
        )
    }
}
