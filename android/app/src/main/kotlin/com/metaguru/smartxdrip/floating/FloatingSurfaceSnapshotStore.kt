package com.metaguru.smartxdrip.floating

import android.content.Context
import org.json.JSONArray
import org.json.JSONObject

data class FloatingSurfaceSegmentSnapshot(
    val id: String,
    val kind: String,
    val primaryText: String,
    val secondaryText: String?,
    val metaText: String?,
    val level: String,
    val components: List<FloatingSurfaceComponentSnapshot> = emptyList()
)

data class FloatingSurfaceComponentSnapshot(
    val label: String,
    val level: String,
    val glyph: String,
    val scoreLabel: String
)

data class FloatingSurfaceSnapshot(
    val layout: String,
    val x: Int,
    val y: Int,
    val segments: List<FloatingSurfaceSegmentSnapshot>
)

class FloatingSurfaceSnapshotStore(private val context: Context) {
    private val prefs = context.getSharedPreferences("floating_surface", Context.MODE_PRIVATE)

    fun save(arguments: Map<String, Any?>) {
        val segments = arguments["segments"] as? List<*> ?: emptyList<Any?>()
        val segmentJson = JSONArray()
        for (item in segments) {
            val segment = item as? Map<*, *> ?: continue
            segmentJson.put(
                JSONObject()
                    .put("id", segment["id"] as? String ?: "")
                    .put("kind", segment["kind"] as? String ?: "status")
                    .put("primaryText", segment["primaryText"] as? String ?: "")
                    .put("secondaryText", segment["secondaryText"] as? String)
                    .put("metaText", segment["metaText"] as? String)
                    .put("level", segment["level"] as? String ?: "unknown")
                    .put("components", componentsJson(segment["data"] as? Map<*, *>))
            )
        }
        prefs.edit()
            .putInt("schemaVersion", (arguments["schemaVersion"] as? Number)?.toInt() ?: 1)
            .putString("layout", arguments["layout"] as? String ?: "stacked")
            .putString("segments", segmentJson.toString())
            .apply()
    }

    fun savePosition(x: Int, y: Int) {
        prefs.edit().putInt("x", x).putInt("y", y).apply()
    }

    fun load(): FloatingSurfaceSnapshot {
        val schemaVersion = prefs.getInt("schemaVersion", 1)
        if (schemaVersion < 2) {
            return FloatingSurfaceSnapshot(
                layout = "stacked",
                x = prefs.getInt("x", 24),
                y = prefs.getInt("y", 120),
                segments = emptyList()
            )
        }
        val segments = mutableListOf<FloatingSurfaceSegmentSnapshot>()
        val raw = prefs.getString("segments", "[]") ?: "[]"
        val array = runCatching { JSONArray(raw) }.getOrElse { JSONArray() }
        for (index in 0 until array.length()) {
            val item = array.optJSONObject(index) ?: continue
            val primaryText = item.optString("primaryText")
            if (primaryText.isBlank()) continue
            segments.add(
                FloatingSurfaceSegmentSnapshot(
                    id = item.optString("id"),
                    kind = item.optString("kind", "status"),
                    primaryText = primaryText,
                    secondaryText = item.optNullableString("secondaryText"),
                    metaText = item.optNullableString("metaText"),
                    level = item.optString("level", "unknown"),
                    components = item.optComponents()
                )
            )
        }
        return FloatingSurfaceSnapshot(
            layout = prefs.getString("layout", "stacked") ?: "stacked",
            x = prefs.getInt("x", 24),
            y = prefs.getInt("y", 120),
            segments = segments
        )
    }

    private fun JSONObject.optNullableString(name: String): String? {
        if (!has(name) || isNull(name)) return null
        return optString(name).takeIf { it.isNotBlank() }
    }

    private fun componentsJson(data: Map<*, *>?): JSONArray {
        val source = data?.get("components") as? List<*> ?: return JSONArray()
        val target = JSONArray()
        for (item in source) {
            val component = item as? Map<*, *> ?: continue
            target.put(
                JSONObject()
                    .put("label", component["label"] as? String ?: "")
                    .put("level", component["level"] as? String ?: "unknown")
                    .put("glyph", component["glyph"] as? String ?: "")
                    .put("scoreLabel", component["scoreLabel"] as? String ?: "--")
            )
        }
        return target
    }

    private fun JSONObject.optComponents(): List<FloatingSurfaceComponentSnapshot> {
        val array = optJSONArray("components") ?: return emptyList()
        val result = mutableListOf<FloatingSurfaceComponentSnapshot>()
        for (index in 0 until array.length()) {
            val item = array.optJSONObject(index) ?: continue
            val label = item.optString("label")
            if (label.isBlank()) continue
            result.add(
                FloatingSurfaceComponentSnapshot(
                    label = label,
                    level = item.optString("level", "unknown"),
                    glyph = item.optString("glyph"),
                    scoreLabel = item.optString("scoreLabel", "--")
                )
            )
        }
        return result
    }
}
