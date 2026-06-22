package com.metaguru.smartxdrip.statusmonitor.floating

import android.content.Context
import android.graphics.Color
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.view.Gravity
import android.view.View
import android.widget.LinearLayout
import android.widget.TextView

class StatusFloatingViewFactory(private val context: Context) {
    fun create(snapshot: StatusFloatingSnapshot): View {
        val color = levelColor(snapshot.level)
        val root = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
            setPadding(13.dp, 9.dp, 13.dp, 9.dp)
            background = GradientDrawable().apply {
                shape = GradientDrawable.RECTANGLE
                cornerRadius = 999f
                setColor(Color.parseColor("#EE121C18"))
                setStroke(1.dp, color)
            }
        }
        root.addView(label("⋮", color, 15, true))
        addGap(root, 7)
        val visible = if (snapshot.collapsed) {
            snapshot.components.take(1)
        } else {
            snapshot.components.take(3)
        }
        visible.forEachIndexed { index, component ->
            root.addView(label(component.glyph, levelColor(component.level), 11, true))
            addGap(root, 4)
            root.addView(label(component.label, Color.parseColor("#D6EDE3"), 12, true))
            if (index != visible.lastIndex) addGap(root, 10)
        }
        if (snapshot.isStale || !snapshot.hasConfiguredSource) {
            addGap(root, 9)
            root.addView(label(if (snapshot.isStale) "stale" else "offline", Color.parseColor("#82958D"), 10, false))
        }
        return root
    }

    private fun label(text: String, color: Int, sp: Int, bold: Boolean): TextView {
        return TextView(context).apply {
            this.text = text
            setTextColor(color)
            textSize = sp.toFloat()
            includeFontPadding = false
            if (bold) typeface = Typeface.DEFAULT_BOLD
        }
    }

    private fun addGap(root: LinearLayout, width: Int) {
        root.addView(View(context), LinearLayout.LayoutParams(width.dp, 1))
    }

    private fun levelColor(level: String): Int {
        return when (level) {
            "healthy" -> Color.rgb(110, 232, 158)
            "watch" -> Color.rgb(240, 180, 78)
            "issue" -> Color.rgb(240, 120, 118)
            else -> Color.rgb(130, 149, 141)
        }
    }

    private val Int.dp: Int
        get() = (this * context.resources.displayMetrics.density).toInt()
}
