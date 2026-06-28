package com.metaguru.smartxdrip.statusmonitor.xdrip.parsing

import android.content.Intent

class XdripBroadcastParserRegistry(
    private val parsers: List<XdripBroadcastParser> = listOf(
        BgEstimateBroadcastParser()
    )
) {
    fun parse(intent: Intent): XdripBroadcastParseResult? {
        return parsers.firstOrNull { it.supports(intent.action) }?.parse(intent)
    }
}
