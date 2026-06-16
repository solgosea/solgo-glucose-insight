package com.metaguru.smartxdrip.floating

import android.content.Context
import android.content.Intent
import com.metaguru.smartxdrip.MainActivity

object FloatingSurfaceTapActionHandler {
    fun openApp(context: Context) {
        val intent = Intent(context, MainActivity::class.java)
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP)
        context.startActivity(intent)
    }
}
