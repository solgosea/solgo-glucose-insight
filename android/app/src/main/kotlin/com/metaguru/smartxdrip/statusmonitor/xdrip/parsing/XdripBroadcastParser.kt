package com.metaguru.smartxdrip.statusmonitor.xdrip.parsing

import android.content.Intent

interface XdripBroadcastParser {
    fun supports(action: String?): Boolean
    fun parse(intent: Intent, nowMs: Long = System.currentTimeMillis()): XdripBroadcastParseResult?
}
