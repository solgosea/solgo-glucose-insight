package com.metaguru.smartxdrip.statusmonitor.aaps

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class AapsEvidenceReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent?) {
        if (intent?.action == ACTION_CLEAR) {
            AapsEvidenceSnapshotStore(context).clear()
            return
        }
        if (intent?.action != ACTION_CONTEXT) return
        AapsEvidenceSnapshotStore(context).save(intent)
    }

    companion object {
        const val ACTION_CONTEXT = "com.metaguru.probe.AAPS_CONTEXT"
        const val ACTION_CLEAR = "com.metaguru.smartxdrip.statusmonitor.CLEAR_AAPS_PROBE"
    }
}
