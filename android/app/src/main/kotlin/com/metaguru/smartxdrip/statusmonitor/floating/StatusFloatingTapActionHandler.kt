package com.metaguru.smartxdrip.statusmonitor.floating

import android.content.Context
import android.content.Intent
import com.metaguru.smartxdrip.MainActivity

object StatusFloatingTapActionHandler {
    fun openApp(context: Context) {
        val intent = Intent(context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP
        }
        context.startActivity(intent)
    }
}
