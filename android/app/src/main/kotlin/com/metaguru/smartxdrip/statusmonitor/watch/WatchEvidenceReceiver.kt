package com.metaguru.smartxdrip.statusmonitor.watch

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class WatchEvidenceReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent?) {
        if (intent?.action == ACTION_CLEAR) {
            WatchEvidenceSnapshotStore(context).clear()
            return
        }
        if (intent?.action != ACTION_DISPLAY) return
        WatchEvidenceSnapshotStore(context).save(intent)
    }

    companion object {
        const val ACTION_DISPLAY = "com.metaguru.probe.WATCHDRIP_DISPLAY"
        const val ACTION_CLEAR = "com.metaguru.smartxdrip.statusmonitor.CLEAR_WATCH_PROBE"
    }
}
