package com.metaguru.smartxdrip.statusmonitor.floating

import android.app.Service
import android.content.Intent
import android.graphics.PixelFormat
import android.os.Build
import android.os.IBinder
import android.provider.Settings
import android.view.Gravity
import android.view.View
import android.view.WindowManager

class StatusFloatingOverlayService : Service() {
    private var windowManager: WindowManager? = null
    private var floatingView: View? = null
    private lateinit var store: StatusFloatingSnapshotStore

    override fun onCreate() {
        super.onCreate()
        activeService = this
        store = StatusFloatingSnapshotStore(this)
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
        if (snapshot.mode != "enabled") {
            removeView()
            stopSelf()
            return
        }
        removeView()
        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.WRAP_CONTENT,
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
            x = snapshot.x
            y = snapshot.y
        }
        val view = StatusFloatingViewFactory(this).create(snapshot)
        view.setOnTouchListener(
            StatusFloatingDragController(
                windowManager = manager,
                params = params,
                onPositionChanged = store::savePosition,
                onClick = { StatusFloatingTapActionHandler.openApp(this) }
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
        var activeService: StatusFloatingOverlayService? = null
            private set
    }
}
