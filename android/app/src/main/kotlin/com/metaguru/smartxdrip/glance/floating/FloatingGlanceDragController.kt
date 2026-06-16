package com.metaguru.smartxdrip.glance.floating

import android.view.MotionEvent
import android.view.View
import android.view.WindowManager
import kotlin.math.abs

class FloatingGlanceDragController(
    private val windowManager: WindowManager,
    private val params: WindowManager.LayoutParams,
    private val onPositionChanged: (Int, Int) -> Unit,
    private val onClick: () -> Unit
) : View.OnTouchListener {
    private var startX = 0
    private var startY = 0
    private var downRawX = 0f
    private var downRawY = 0f
    private var moved = false

    override fun onTouch(view: View, event: MotionEvent): Boolean {
        when (event.action) {
            MotionEvent.ACTION_DOWN -> {
                startX = params.x
                startY = params.y
                downRawX = event.rawX
                downRawY = event.rawY
                moved = false
                return true
            }
            MotionEvent.ACTION_MOVE -> {
                val dx = (event.rawX - downRawX).toInt()
                val dy = (event.rawY - downRawY).toInt()
                if (abs(dx) > 6 || abs(dy) > 6) moved = true
                params.x = startX + dx
                params.y = startY + dy
                windowManager.updateViewLayout(view, params)
                return true
            }
            MotionEvent.ACTION_UP -> {
                onPositionChanged(params.x, params.y)
                if (!moved) onClick()
                return true
            }
        }
        return false
    }
}
