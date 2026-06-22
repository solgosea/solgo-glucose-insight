package com.metaguru.smartxdrip.floating

import android.app.Service
import android.content.Intent
import android.graphics.PixelFormat
import android.os.Build
import android.os.IBinder
import android.provider.Settings
import android.view.Gravity
import android.view.View
import android.view.WindowManager

class FloatingSurfaceOverlayService : Service() {
    private var windowManager: WindowManager? = null
    private var floatingView: View? = null
    private lateinit var store: FloatingSurfaceSnapshotStore

    override fun onCreate() {
        super.onCreate()
        activeService = this
        store = FloatingSurfaceSnapshotStore(this)
        windowManager = getSystemService(WINDOW_SERVICE) as WindowManager
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (!Settings.canDrawOverlays(this)) {
            stopSelf()
            return START_NOT_STICKY
        }
        render()
        return START_STICKY
    }

    override fun onDestroy() {
        removeView()
        if (activeService === this) activeService = null
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    fun render() {
        val manager = windowManager ?: return
        val snapshot = store.load()
        if (snapshot.segments.isEmpty()) {
            removeView()
            stopSelf()
            return
        }
        removeView()
        val overlayWidth = overlayWidth(snapshot)
        val overlayHeight = overlayHeight(snapshot)
        val maxX = (resources.displayMetrics.widthPixels - overlayWidth - 8.dp).coerceAtLeast(0)
        val maxY = (resources.displayMetrics.heightPixels - overlayHeight - 24.dp).coerceAtLeast(0)
        val clampedX = snapshot.x.coerceIn(0, maxX)
        val clampedY = snapshot.y.coerceIn(0, maxY)
        if (clampedX != snapshot.x || clampedY != snapshot.y) {
            store.savePosition(clampedX, clampedY)
        }
        val params = WindowManager.LayoutParams(
            overlayWidth,
            WindowManager.LayoutParams.WRAP_CONTENT,
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
            } else {
                @Suppress("DEPRECATION")
                WindowManager.LayoutParams.TYPE_PHONE
            },
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
                WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS,
            PixelFormat.TRANSLUCENT
        ).apply {
            gravity = Gravity.TOP or Gravity.START
            x = clampedX
            y = clampedY
        }
        val view = FloatingSurfaceViewFactory(this).create(snapshot)
        view.setOnTouchListener(
            FloatingSurfaceDragController(
                windowManager = manager,
                params = params,
                onPositionChanged = store::savePosition,
                onClick = { x, y, width, height ->
                    handleClick(snapshot, width, height, x, y)
                }
            )
        )
        manager.addView(view, params)
        floatingView = view
    }

    private fun handleClick(
        snapshot: FloatingSurfaceSnapshot,
        overlayWidth: Int,
        overlayHeight: Int,
        x: Float,
        y: Float
    ) {
        if (snapshot.isSingleGlance()) {
            if (snapshot.overlayState == "expanded") {
                val sizePreset = sizePresetHit(overlayWidth, overlayHeight, x, y)
                if (sizePreset != null) {
                    FloatingSurfaceActionBus.dispatch(
                        segmentId = "glance",
                        action = "set_size_preset",
                        value = sizePreset
                    )
                    return
                }
            }
            val next = if (snapshot.overlayState == "expanded") "compact" else "expanded"
            store.saveOverlayState(next)
            render()
            return
        }
        FloatingSurfaceTapActionHandler.openApp(this)
    }

    private fun sizePresetHit(
        overlayWidth: Int,
        overlayHeight: Int,
        x: Float,
        y: Float
    ): String? {
        val rowTop = overlayHeight - 67.dp
        val rowBottom = overlayHeight - 31.dp
        if (y < rowTop || y > rowBottom) return null
        val chipWidth = 30.dp
        val gap = 6.dp
        val startX = overlayWidth - 18.dp - (chipWidth * 3 + gap * 2)
        if (x < startX || x > overlayWidth - 12.dp) return null
        val options = listOf("small", "medium", "large")
        for (index in options.indices) {
            val left = startX + index * (chipWidth + gap)
            val right = left + chipWidth
            if (x >= left && x <= right) return options[index]
        }
        return null
    }

    private fun removeView() {
        val manager = windowManager ?: return
        floatingView?.let {
            runCatching { manager.removeView(it) }
        }
        floatingView = null
    }

    companion object {
        var activeService: FloatingSurfaceOverlayService? = null
            private set
    }

    private fun overlayWidth(snapshot: FloatingSurfaceSnapshot): Int {
        val screenWidth = resources.displayMetrics.widthPixels
        val glance = snapshot.singleGlanceSegment()
        val size = glance?.data?.optString("sizePreset", "medium") ?: "medium"
        val desired = when {
            snapshot.isSingleGlance() && snapshot.overlayState == "expanded" -> when (size) {
                "small" -> 276.dp
                "large" -> 380.dp
                else -> 324.dp
            }
            snapshot.isSingleGlance() -> when (size) {
                "small" -> 184.dp
                "large" -> 286.dp
                else -> 244.dp
            }
            snapshot.segments.size > 1 -> 286.dp
            else -> 232.dp
        }
        return desired.coerceAtMost(screenWidth - 32.dp)
    }

    private fun overlayHeight(snapshot: FloatingSurfaceSnapshot): Int {
        val glance = snapshot.singleGlanceSegment()
        val size = glance?.data?.optString("sizePreset", "medium") ?: "medium"
        val form = glance?.data?.optString("formFactor", "pill") ?: "pill"
        return when {
            snapshot.isSingleGlance() && snapshot.overlayState == "expanded" -> when (size) {
                "small" -> 218.dp
                "large" -> 286.dp
                else -> 248.dp
            }
            snapshot.isSingleGlance() -> when (size) {
                "small" -> if (form == "card") 58.dp else 50.dp
                "large" -> if (form == "card") 78.dp else 70.dp
                else -> if (form == "card") 64.dp else 56.dp
            }
            snapshot.segments.size > 1 -> 64.dp
            else -> 44.dp
        }
    }

    private fun FloatingSurfaceSnapshot.isSingleGlance(): Boolean {
        return segments.size == 1 && segments.firstOrNull()?.id == "glance"
    }

    private fun FloatingSurfaceSnapshot.singleGlanceSegment(): FloatingSurfaceSegmentSnapshot? {
        if (!isSingleGlance()) return null
        return segments.firstOrNull()
    }

    private val Int.dp: Int
        get() = (this * resources.displayMetrics.density).toInt()
}
