package com.metaguru.smartxdrip.statusmonitor.xdrip

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.metaguru.smartxdrip.statusmonitor.xdrip.parsing.XdripBroadcastParserRegistry

class XdripBroadcastReceiver : BroadcastReceiver() {
    private val parsers = XdripBroadcastParserRegistry()

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == "com.metaguru.smartxdrip.statusmonitor.CLEAR_XDRIP_PROBE") {
            XdripBroadcastSnapshotStore(context).clear()
            return
        }
        val payload = parsers.parse(intent) ?: return
        XdripBroadcastSnapshotStore(context).save(payload)
    }
}
