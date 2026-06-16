package com.metaguru.smartxdrip.glance.floating

import android.content.Context

data class FloatingGlanceSnapshot(
    val mode: String,
    val displayStyle: String,
    val x: Int,
    val y: Int,
    val collapsed: Boolean,
    val valueLabel: String,
    val unitLabel: String,
    val trendArrow: String,
    val deltaLabel: String,
    val freshnessLabel: String,
    val rangeState: String,
    val hasReading: Boolean,
    val sourceLabel: String,
    val isStale: Boolean
)

class FloatingGlanceSnapshotStore(private val context: Context) {
    private val prefs = context.getSharedPreferences("floating_glance", Context.MODE_PRIVATE)

    fun save(arguments: Map<String, Any?>) {
        prefs.edit()
            .putString("mode", arguments["mode"] as? String ?: "enabled")
            .putString("displayStyle", arguments["displayStyle"] as? String ?: "pill")
            .putInt("x", (arguments["x"] as? Number)?.toInt() ?: prefs.getInt("x", 24))
            .putInt("y", (arguments["y"] as? Number)?.toInt() ?: prefs.getInt("y", 120))
            .putBoolean("collapsed", arguments["collapsed"] as? Boolean ?: false)
            .putString("valueLabel", arguments["valueLabel"] as? String ?: "--")
            .putString("unitLabel", arguments["unitLabel"] as? String ?: "")
            .putString("trendArrow", arguments["trendArrow"] as? String ?: "→")
            .putString("deltaLabel", arguments["deltaLabel"] as? String ?: "")
            .putString("freshnessLabel", arguments["freshnessLabel"] as? String ?: "No recent data")
            .putString("rangeState", arguments["rangeState"] as? String ?: "unknown")
            .putBoolean("hasReading", arguments["hasReading"] as? Boolean ?: false)
            .putString("sourceLabel", arguments["sourceLabel"] as? String ?: "Solgo Insight")
            .putBoolean("isStale", arguments["isStale"] as? Boolean ?: true)
            .apply()
    }

    fun savePosition(x: Int, y: Int) {
        prefs.edit().putInt("x", x).putInt("y", y).apply()
    }

    fun saveCollapsed(collapsed: Boolean) {
        prefs.edit().putBoolean("collapsed", collapsed).apply()
    }

    fun load(): FloatingGlanceSnapshot {
        return FloatingGlanceSnapshot(
            mode = prefs.getString("mode", "enabled") ?: "enabled",
            displayStyle = prefs.getString("displayStyle", "pill") ?: "pill",
            x = prefs.getInt("x", 24),
            y = prefs.getInt("y", 120),
            collapsed = prefs.getBoolean("collapsed", false),
            valueLabel = prefs.getString("valueLabel", "--") ?: "--",
            unitLabel = prefs.getString("unitLabel", "") ?: "",
            trendArrow = prefs.getString("trendArrow", "→") ?: "→",
            deltaLabel = prefs.getString("deltaLabel", "") ?: "",
            freshnessLabel = prefs.getString("freshnessLabel", "No recent data") ?: "No recent data",
            rangeState = prefs.getString("rangeState", "unknown") ?: "unknown",
            hasReading = prefs.getBoolean("hasReading", false),
            sourceLabel = prefs.getString("sourceLabel", "Solgo Insight") ?: "Solgo Insight",
            isStale = prefs.getBoolean("isStale", true)
        )
    }
}
