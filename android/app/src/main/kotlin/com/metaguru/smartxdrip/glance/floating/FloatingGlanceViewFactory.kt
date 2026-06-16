package com.metaguru.smartxdrip.glance.floating

import android.content.Context
import android.graphics.Color
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.view.Gravity
import android.view.View
import android.widget.LinearLayout
import android.widget.TextView

class FloatingGlanceViewFactory(private val context: Context) {
    fun create(
        snapshot: FloatingGlanceSnapshot,
        onCollapse: () -> Unit,
        onDismiss: () -> Unit
    ): View {
        val color = stateColor(snapshot)
        val root = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
            setPadding(14.dp, 9.dp, 10.dp, 9.dp)
            background = GradientDrawable().apply {
                shape = GradientDrawable.RECTANGLE
                cornerRadius = 999f
                setColor(Color.parseColor("#EE17211D"))
                setStroke(1.dp, color)
            }
        }
        root.addView(label("⋮", color, 14, true))
        addGap(root, 6)
        if (snapshot.collapsed) {
            root.addView(label(snapshot.trendArrow, color, 15, true))
        } else {
            val value = if (snapshot.hasReading && !snapshot.isStale) {
                "${snapshot.valueLabel} ${snapshot.unitLabel}"
            } else if (snapshot.isStale) {
                "Stale"
            } else {
                "Offline"
            }
            root.addView(label(value, color, 13, true))
            addGap(root, 8)
            root.addView(label("${snapshot.trendArrow} ${snapshot.deltaLabel}", Color.parseColor("#C8D8D0"), 11, true))
            addGap(root, 8)
            root.addView(label(snapshot.freshnessLabel, Color.parseColor("#82958D"), 10, false))
        }
        addGap(root, 8)
        root.addView(button(if (snapshot.collapsed) "+" else "-", onCollapse))
        addGap(root, 3)
        root.addView(button("×", onDismiss))
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

    private fun button(text: String, onClick: () -> Unit): TextView {
        return TextView(context).apply {
            this.text = text
            setTextColor(Color.parseColor("#B8C8C0"))
            textSize = 13f
            gravity = Gravity.CENTER
            includeFontPadding = false
            setPadding(6.dp, 2.dp, 6.dp, 2.dp)
            setOnClickListener { onClick() }
        }
    }

    private fun addGap(root: LinearLayout, width: Int) {
        root.addView(View(context), LinearLayout.LayoutParams(width.dp, 1))
    }

    private fun stateColor(snapshot: FloatingGlanceSnapshot): Int {
        if (!snapshot.hasReading || snapshot.isStale) return Color.parseColor("#82958D")
        return when (snapshot.rangeState) {
            "high" -> Color.parseColor("#F2C66D")
            "low" -> Color.parseColor("#FF7E93")
            "in_range" -> Color.parseColor("#6EE89F")
            else -> Color.parseColor("#82958D")
        }
    }

    private val Int.dp: Int
        get() = (this * context.resources.displayMetrics.density).toInt()
}
