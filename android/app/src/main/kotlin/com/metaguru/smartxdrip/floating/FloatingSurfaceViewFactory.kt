package com.metaguru.smartxdrip.floating

import android.content.Context
import android.graphics.Color
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.text.TextUtils
import android.view.Gravity
import android.view.View
import android.widget.LinearLayout
import android.widget.TextView

class FloatingSurfaceViewFactory(private val context: Context) {
    fun create(snapshot: FloatingSurfaceSnapshot): View {
        val root = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER_VERTICAL
            setPadding(14.dp, 10.dp, 14.dp, 10.dp)
            minimumWidth = surfaceWidth(snapshot)
            background = GradientDrawable().apply {
                shape = GradientDrawable.RECTANGLE
                cornerRadius = 18.dp.toFloat()
                setColor(Color.parseColor("#F017211D"))
                setStroke(1.dp, borderColor(snapshot.segments))
            }
        }
        snapshot.segments.forEachIndexed { index, segment ->
            if (index > 0) addVerticalGap(root, 5)
            root.addView(segmentRow(segment))
        }
        return root
    }

    private fun segmentRow(segment: FloatingSurfaceSegmentSnapshot): View {
        val row = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                if (segment.kind == "glucose") 22.dp else 18.dp
            )
        }
        if (segment.kind == "glucose") {
            row.addView(
                label(segment.primaryText, levelColor(segment.level), 15, true),
                LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f)
            )
            addHorizontalGap(row, 8)
            segment.secondaryText?.let {
                row.addView(label(it, Color.parseColor("#CFE0D7"), 12, true))
                addHorizontalGap(row, 8)
            }
            segment.metaText?.let {
                row.addView(label(it, Color.parseColor("#8FA198"), 11, false))
            }
        } else {
            if (segment.components.isEmpty()) {
                row.addView(
                    label(segment.primaryText, levelColor(segment.level), 12, true),
                    LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f)
                )
            } else {
                val componentsRow = LinearLayout(context).apply {
                    orientation = LinearLayout.HORIZONTAL
                    gravity = Gravity.CENTER_VERTICAL
                }
                segment.components.forEachIndexed { index, component ->
                    if (index > 0) addHorizontalGap(componentsRow, 10)
                    componentsRow.addView(componentChip(component))
                }
                row.addView(
                    componentsRow,
                    LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f)
                )
            }
            segment.metaText?.let {
                addHorizontalGap(row, 8)
                row.addView(label(it, Color.parseColor("#7E9088"), 10, false))
            }
        }
        return row
    }

    private fun componentChip(component: FloatingSurfaceComponentSnapshot): View {
        val row = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
        }
        val color = levelColor(component.level)
        row.addView(label(component.glyph, color, 11, true))
        addHorizontalGap(row, 4)
        row.addView(label("${component.label} ${component.scoreLabel}", color, 12, true))
        return row
    }

    private fun label(text: String, color: Int, sp: Int, bold: Boolean): TextView {
        return TextView(context).apply {
            this.text = text
            setTextColor(color)
            textSize = sp.toFloat()
            includeFontPadding = false
            maxLines = 1
            ellipsize = TextUtils.TruncateAt.END
            if (bold) typeface = Typeface.DEFAULT_BOLD
        }
    }

    private fun addHorizontalGap(root: LinearLayout, width: Int) {
        root.addView(View(context), LinearLayout.LayoutParams(width.dp, 1))
    }

    private fun addVerticalGap(root: LinearLayout, height: Int) {
        root.addView(View(context), LinearLayout.LayoutParams(1, height.dp))
    }

    private fun borderColor(segments: List<FloatingSurfaceSegmentSnapshot>): Int {
        if (segments.any { it.level == "issue" }) return levelColor("issue")
        if (segments.any { it.level == "watch" }) return levelColor("watch")
        if (segments.any { it.level == "healthy" }) return levelColor("healthy")
        return levelColor("unknown")
    }

    private fun levelColor(level: String): Int {
        return when (level) {
            "healthy" -> Color.parseColor("#6EE89F")
            "watch" -> Color.parseColor("#F2C66D")
            "issue" -> Color.parseColor("#FF7E93")
            else -> Color.parseColor("#82958D")
        }
    }

    private fun surfaceWidth(snapshot: FloatingSurfaceSnapshot): Int {
        val screenWidth = context.resources.displayMetrics.widthPixels
        val desired = if (snapshot.segments.size > 1) 286.dp else 232.dp
        return desired.coerceAtMost(screenWidth - 32.dp)
    }

    private val Int.dp: Int
        get() = (this * context.resources.displayMetrics.density).toInt()
}
