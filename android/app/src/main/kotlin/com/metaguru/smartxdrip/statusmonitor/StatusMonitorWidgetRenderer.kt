package com.metaguru.smartxdrip.statusmonitor

import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.view.View
import android.widget.RemoteViews
import com.metaguru.smartxdrip.MainActivity
import com.metaguru.smartxdrip.R

class StatusMonitorWidgetRenderer {
    fun renderSafe(context: Context, layoutId: Int): RemoteViews {
        return try {
            render(context, layoutId)
        } catch (_: Throwable) {
            renderFallback(context, layoutId)
        }
    }

    fun render(context: Context, layoutId: Int): RemoteViews {
        val snapshot = StatusMonitorWidgetSnapshotStore(context).load()
        val views = RemoteViews(context.packageName, layoutId)
        val accent = levelColor(snapshot.level)
        views.setInt(R.id.status_widget_accent, "setBackgroundColor", accent)
        views.setTextViewText(R.id.status_widget_headline, headline(snapshot, layoutId))
        views.setTextViewText(R.id.status_widget_summary, snapshot.summary)
        views.setTextViewText(R.id.status_widget_source, snapshot.sourceLabel)
        views.setTextViewText(R.id.status_widget_updated, snapshot.updatedLabel)
        views.setTextColor(R.id.status_widget_headline, headlineColor(snapshot.level, layoutId))
        setOptionalText(views, R.id.status_widget_score, snapshot.scoreLabel)
        setOptionalText(views, R.id.status_widget_state, statusLabel(snapshot.level))
        setOptionalText(views, R.id.status_widget_mark, glyph(snapshot.level))
        setOptionalTextColor(views, R.id.status_widget_mark, accent)
        setOptionalTextColor(views, R.id.status_widget_score, accent)
        bindConnectors(views, layoutId, snapshot.sensorToUploader, snapshot.uploaderToServer)
        val useShortNames = layoutId != R.layout.widget_status_monitor_detailed
        val highlightRows = layoutId == R.layout.widget_status_monitor_detailed
        bindComponent(views, 0, snapshot.components.getOrNull(0), useShortNames, highlightRows)
        bindComponent(views, 1, snapshot.components.getOrNull(1), useShortNames, highlightRows)
        bindComponent(views, 2, snapshot.components.getOrNull(2), useShortNames, highlightRows)
        views.setOnClickPendingIntent(R.id.status_widget_root, openAppIntent(context))
        return views
    }

    private fun headline(snapshot: StatusMonitorWidgetSnapshot, layoutId: Int): String {
        return when (layoutId) {
            R.layout.widget_status_monitor_compact -> snapshot.headline
            R.layout.widget_status_monitor_issue -> issueHeadline(snapshot)
            else -> snapshot.headline
        }
    }

    private fun issueHeadline(snapshot: StatusMonitorWidgetSnapshot): String {
        val issue = snapshot.components.firstOrNull { it.level == "issue" }
            ?: snapshot.components.firstOrNull { it.level == "watch" }
        return issue?.let { "${shortName(it.title)} needs attention" } ?: snapshot.headline
    }

    private fun bindComponent(
        views: RemoteViews,
        index: Int,
        component: StatusMonitorWidgetComponent?,
        useShortName: Boolean,
        highlightRow: Boolean
    ) {
        val nameId = when (index) {
            0 -> R.id.status_widget_component_1_name
            1 -> R.id.status_widget_component_2_name
            else -> R.id.status_widget_component_3_name
        }
        val levelId = when (index) {
            0 -> R.id.status_widget_component_1_level
            1 -> R.id.status_widget_component_2_level
            else -> R.id.status_widget_component_3_level
        }
        val glyphId = when (index) {
            0 -> R.id.status_widget_component_1_glyph
            1 -> R.id.status_widget_component_2_glyph
            else -> R.id.status_widget_component_3_glyph
        }
        val detailId = when (index) {
            0 -> R.id.status_widget_component_1_detail
            1 -> R.id.status_widget_component_2_detail
            else -> R.id.status_widget_component_3_detail
        }
        val rowId = when (index) {
            0 -> R.id.status_widget_component_1
            1 -> R.id.status_widget_component_2
            else -> R.id.status_widget_component_3
        }
        if (component == null) {
            views.setViewVisibility(rowId, View.GONE)
            return
        }
        val color = levelColor(component.level)
        views.setTextViewText(nameId, if (useShortName) shortName(component.title) else component.title)
        views.setTextViewText(levelId, component.scoreLabel)
        views.setTextViewText(glyphId, glyph(component.level))
        setOptionalText(views, detailId, component.detail)
        views.setTextColor(levelId, color)
        views.setTextColor(glyphId, color)
        if (highlightRow) {
            setOptionalRowBackground(views, rowId, component.level)
        }
        setOptionalTextColor(views, detailId, when (component.level) {
            "healthy" -> Color.rgb(77, 114, 100)
            else -> color
        })
    }

    private fun glyph(level: String): String {
        return when (level) {
            "healthy" -> "\u25CF"
            "watch" -> "\u25B2"
            "issue" -> "\u25A0"
            else -> "\u25CB"
        }
    }

    private fun renderFallback(context: Context, layoutId: Int): RemoteViews {
        val views = RemoteViews(context.packageName, layoutId)
        views.setInt(R.id.status_widget_accent, "setBackgroundColor", levelColor("unknown"))
        views.setTextViewText(R.id.status_widget_headline, "Status unavailable")
        views.setTextViewText(R.id.status_widget_summary, "Open SolgoInsight to refresh status")
        views.setTextViewText(R.id.status_widget_source, "No source")
        views.setTextViewText(R.id.status_widget_updated, "Not updated")
        views.setTextViewText(R.id.status_widget_component_1_name, "CGM Sensor")
        views.setTextViewText(R.id.status_widget_component_1_level, "--")
        views.setTextViewText(R.id.status_widget_component_1_glyph, glyph("unknown"))
        setOptionalText(views, R.id.status_widget_component_1_detail, "Open app to refresh")
        views.setTextViewText(R.id.status_widget_component_2_name, "xDrip+")
        views.setTextViewText(R.id.status_widget_component_2_level, "--")
        views.setTextViewText(R.id.status_widget_component_2_glyph, glyph("unknown"))
        setOptionalText(views, R.id.status_widget_component_2_detail, "No recent status")
        views.setTextViewText(R.id.status_widget_component_3_name, "Nightscout")
        views.setTextViewText(R.id.status_widget_component_3_level, "--")
        views.setTextViewText(R.id.status_widget_component_3_glyph, glyph("unknown"))
        setOptionalText(views, R.id.status_widget_component_3_detail, "No source")
        setOptionalText(views, R.id.status_widget_mark, glyph("unknown"))
        setOptionalText(views, R.id.status_widget_score, "--")
        setOptionalText(views, R.id.status_widget_state, statusLabel("unknown"))
        bindConnectors(views, layoutId, "unknown", "unknown")
        views.setOnClickPendingIntent(R.id.status_widget_root, openAppIntent(context))
        return views
    }

    private fun setOptionalText(views: RemoteViews, id: Int, text: String) {
        try {
            views.setTextViewText(id, text)
        } catch (_: Throwable) {
        }
    }

    private fun setOptionalTextColor(views: RemoteViews, id: Int, color: Int) {
        try {
            views.setTextColor(id, color)
        } catch (_: Throwable) {
        }
    }

    private fun setOptionalBackground(views: RemoteViews, id: Int, color: Int) {
        try {
            views.setInt(id, "setBackgroundColor", color)
        } catch (_: Throwable) {
        }
    }

    private fun setOptionalRowBackground(views: RemoteViews, id: Int, level: String) {
        val drawable = when (level) {
            "issue" -> R.drawable.status_widget_row_issue_bg
            "watch" -> R.drawable.status_widget_row_watch_bg
            else -> R.drawable.status_widget_row_bg
        }
        try {
            views.setInt(id, "setBackgroundResource", drawable)
        } catch (_: Throwable) {
        }
    }

    private fun bindConnectors(
        views: RemoteViews,
        layoutId: Int,
        first: String,
        second: String
    ) {
        if (layoutId != R.layout.widget_status_monitor_flow &&
            layoutId != R.layout.widget_status_monitor_issue
        ) {
            return
        }
        setOptionalBackground(views, R.id.status_widget_connector_1, connectorColor(first))
        setOptionalBackground(views, R.id.status_widget_connector_2, connectorColor(second))
    }

    private fun headlineColor(level: String, layoutId: Int): Int {
        if (layoutId == R.layout.widget_status_monitor_issue && level == "issue") {
            return levelColor("issue")
        }
        return Color.rgb(214, 237, 227)
    }

    private fun levelColor(level: String): Int {
        return when (level) {
            "healthy" -> Color.rgb(110, 232, 158)
            "watch" -> Color.rgb(240, 180, 78)
            "issue" -> Color.rgb(240, 120, 118)
            else -> Color.rgb(77, 114, 100)
        }
    }

    private fun connectorColor(state: String): Int {
        return when (state) {
            "healthy" -> Color.rgb(110, 232, 158)
            "watch" -> Color.rgb(240, 180, 78)
            "broken" -> Color.rgb(240, 120, 118)
            else -> Color.rgb(77, 114, 100)
        }
    }

    private fun statusLabel(level: String): String {
        return when (level) {
            "healthy" -> "Healthy"
            "watch" -> "Watch"
            "issue" -> "Issue"
            else -> "Unknown"
        }
    }

    private fun shortName(title: String): String {
        val lower = title.lowercase()
        return when {
            lower.contains("sensor") -> "Sensor"
            lower.contains("xdrip") -> "Uploader"
            lower.contains("nightscout") -> "Server"
            else -> title
        }
    }

    private fun openAppIntent(context: Context): PendingIntent {
        val intent = Intent(context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP
        }
        return PendingIntent.getActivity(
            context,
            75102,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
    }
}
