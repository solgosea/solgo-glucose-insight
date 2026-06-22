package com.metaguru.smartxdrip.glance

import android.content.Context
import kotlin.math.max

data class GlanceWidgetSnapshot(
    val valueLabel: String,
    val unitLabel: String,
    val alternateValueLabel: String,
    val deltaLabel: String,
    val trendArrow: String,
    val freshnessLabel: String,
    val tir24hLabel: String,
    val tir24hCompactLabel: String,
    val tir24hPercent: Float?,
    val tir24hReadingCount: Int,
    val sourceLabel: String,
    val rangeState: String,
    val targetLowMmol: Float,
    val targetHighMmol: Float,
    val trendValues: List<Float>
)

data class GlanceWidgetNativeConfig(
    val template: String,
    val backgroundStyle: String,
    val fontSize: String,
    val graphRange: String,
    val showTrendArrow: Boolean,
    val showDelta: Boolean,
    val showLastUpdated: Boolean,
    val showMiniGraph: Boolean,
    val showAlternateUnit: Boolean,
    val tapAction: String
)

class GlanceWidgetSnapshotStore(private val context: Context) {
    private val prefs =
        context.getSharedPreferences("smartxdrip_glance", Context.MODE_PRIVATE)

    fun save(snapshot: Map<String, Any?>) {
        prefs.edit()
            .putString("valueLabel", snapshot["valueLabel"] as? String ?: "--")
            .putString("unitLabel", snapshot["unitLabel"] as? String ?: "mmol/L")
            .putString("alternateValueLabel", snapshot["alternateValueLabel"] as? String ?: "--")
            .putString("deltaLabel", snapshot["deltaLabel"] as? String ?: "+0.0")
            .putString("trendArrow", snapshot["trendArrow"] as? String ?: "->")
            .putString("freshnessLabel", snapshot["freshnessLabel"] as? String ?: "No recent data")
            .putString("tir24hLabel", snapshot["tir24hLabel"] as? String ?: "TIR 24H --")
            .putString("tir24hCompactLabel", snapshot["tir24hCompactLabel"] as? String ?: "TIR --")
            .putFloat("tir24hPercent", (snapshot["tir24hPercent"] as? Number)?.toFloat() ?: -1f)
            .putInt("tir24hReadingCount", (snapshot["tir24hReadingCount"] as? Number)?.toInt() ?: 0)
            .putLong(
                "latestReadingAtMs",
                (snapshot["latestReadingAtMs"] as? Number)?.toLong() ?: 0L
            )
            .putString("sourceLabel", snapshot["sourceLabel"] as? String ?: "SolgoInsight")
            .putString("rangeState", snapshot["rangeState"] as? String ?: "unknown")
            .putFloat("targetLowMmol", (snapshot["targetLowMmol"] as? Number)?.toFloat() ?: 3.9f)
            .putFloat("targetHighMmol", (snapshot["targetHighMmol"] as? Number)?.toFloat() ?: 10.0f)
            .putString("trendValues", encodeTrendValues(snapshot["trendValues"]))
            .apply()
    }

    fun saveConfig(config: Map<String, Any?>) {
        prefs.edit()
            .putString("template", config["template"] as? String ?: "trend")
            .putString("backgroundStyle", config["backgroundStyle"] as? String ?: "dark")
            .putString("fontSize", config["fontSize"] as? String ?: "medium")
            .putString("graphRange", config["graphRange"] as? String ?: "4h")
            .putBoolean("showTrendArrow", config["showTrendArrow"] as? Boolean ?: true)
            .putBoolean("showDelta", config["showDelta"] as? Boolean ?: true)
            .putBoolean("showLastUpdated", config["showLastUpdated"] as? Boolean ?: true)
            .putBoolean("showMiniGraph", config["showMiniGraph"] as? Boolean ?: true)
            .putBoolean("showAlternateUnit", config["showAlternateUnit"] as? Boolean ?: false)
            .putString("tapAction", config["tapAction"] as? String ?: "home")
            .apply()
    }

    fun load(): GlanceWidgetSnapshot {
        val fallbackFreshness =
            prefs.getString("freshnessLabel", "No recent data") ?: "No recent data"
        return GlanceWidgetSnapshot(
            valueLabel = prefs.getString("valueLabel", "--") ?: "--",
            unitLabel = prefs.getString("unitLabel", "mmol/L") ?: "mmol/L",
            alternateValueLabel = prefs.getString("alternateValueLabel", "--") ?: "--",
            deltaLabel = prefs.getString("deltaLabel", "+0.0") ?: "+0.0",
            trendArrow = prefs.getString("trendArrow", "->") ?: "->",
            freshnessLabel = freshnessFromTimestamp(
                prefs.getLong("latestReadingAtMs", 0L),
                fallbackFreshness
            ),
            tir24hLabel = prefs.getString("tir24hLabel", "TIR 24H --") ?: "TIR 24H --",
            tir24hCompactLabel = prefs.getString("tir24hCompactLabel", "TIR --") ?: "TIR --",
            tir24hPercent = prefs.getFloat("tir24hPercent", -1f).takeIf { it >= 0f },
            tir24hReadingCount = prefs.getInt("tir24hReadingCount", 0),
            sourceLabel = prefs.getString("sourceLabel", "SolgoInsight") ?: "SolgoInsight",
            rangeState = prefs.getString("rangeState", "unknown") ?: "unknown",
            targetLowMmol = prefs.getFloat("targetLowMmol", 3.9f),
            targetHighMmol = prefs.getFloat("targetHighMmol", 10.0f),
            trendValues = decodeTrendValues(prefs.getString("trendValues", "") ?: "")
        )
    }

    fun loadConfig(): GlanceWidgetNativeConfig {
        return GlanceWidgetNativeConfig(
            template = prefs.getString("template", "trend") ?: "trend",
            backgroundStyle = prefs.getString("backgroundStyle", "dark") ?: "dark",
            fontSize = prefs.getString("fontSize", "medium") ?: "medium",
            graphRange = prefs.getString("graphRange", "4h") ?: "4h",
            showTrendArrow = prefs.getBoolean("showTrendArrow", true),
            showDelta = prefs.getBoolean("showDelta", true),
            showLastUpdated = prefs.getBoolean("showLastUpdated", true),
            showMiniGraph = prefs.getBoolean("showMiniGraph", true),
            showAlternateUnit = prefs.getBoolean("showAlternateUnit", false),
            tapAction = prefs.getString("tapAction", "home") ?: "home"
        )
    }

    private fun freshnessFromTimestamp(timestampMs: Long, fallback: String): String {
        if (timestampMs <= 0L) return fallback
        val ageMs = max(0L, System.currentTimeMillis() - timestampMs)
        val minutes = ageMs / 60000L
        return when {
            minutes <= 0L -> "just now"
            minutes < 60L -> "$minutes min ago"
            else -> "${minutes / 60L} h ago"
        }
    }

    private fun encodeTrendValues(raw: Any?): String {
        val values = raw as? List<*> ?: return ""
        return values.mapNotNull { (it as? Number)?.toFloat() }.joinToString(",")
    }

    private fun decodeTrendValues(raw: String): List<Float> {
        if (raw.isBlank()) return emptyList()
        return raw.split(",").mapNotNull { it.toFloatOrNull() }
    }
}
