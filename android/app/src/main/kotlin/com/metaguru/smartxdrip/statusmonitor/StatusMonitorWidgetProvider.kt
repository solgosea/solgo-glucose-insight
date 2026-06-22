package com.metaguru.smartxdrip.statusmonitor

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import com.metaguru.smartxdrip.R

open class StatusMonitorWidgetProvider : AppWidgetProvider() {
    open val layoutId: Int = R.layout.widget_status_monitor_flow

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        val renderer = StatusMonitorWidgetRenderer()
        for (appWidgetId in appWidgetIds) {
            appWidgetManager.updateAppWidget(appWidgetId, renderer.renderSafe(context, layoutId))
        }
    }
}

class StatusMonitorCompactWidgetProvider : StatusMonitorWidgetProvider() {
    override val layoutId: Int = R.layout.widget_status_monitor_compact
}

class StatusMonitorFlowWidgetProvider : StatusMonitorWidgetProvider() {
    override val layoutId: Int = R.layout.widget_status_monitor_flow
}

class StatusMonitorIssueWidgetProvider : StatusMonitorWidgetProvider() {
    override val layoutId: Int = R.layout.widget_status_monitor_issue
}

class StatusMonitorDetailedWidgetProvider : StatusMonitorWidgetProvider() {
    override val layoutId: Int = R.layout.widget_status_monitor_detailed
}
