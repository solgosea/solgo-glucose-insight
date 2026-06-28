package com.metaguru.smartxdrip.statusmonitor.juggluco

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.metaguru.smartxdrip.statusmonitor.juggluco.parsing.JugglucoBroadcastParserRegistry

class JugglucoBroadcastReceiver : BroadcastReceiver() {
    private val parsers = JugglucoBroadcastParserRegistry()

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == "com.metaguru.smartxdrip.statusmonitor.CLEAR_JUGGLUCO_PROBE") {
            JugglucoBroadcastSnapshotStore(context).clear()
            return
        }
        val payload = parsers.parse(intent) ?: return
        JugglucoBroadcastSnapshotStore(context).save(payload)
    }
}
