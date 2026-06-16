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
        val overlayHeight = if (snapshot.segments.size > 1) 64.dp else 44.dp
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
                onClick = { FloatingSurfaceTapActionHandler.openApp(this) }
            )
        )
        manager.addView(view, params)
        floatingView = view
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
        val desired = if (snapshot.segments.size > 1) 286.dp else 232.dp
        return desired.coerceAtMost(screenWidth - 32.dp)
    }

    private val Int.dp: Int
        get() = (this * resources.displayMetrics.density).toInt()
}
