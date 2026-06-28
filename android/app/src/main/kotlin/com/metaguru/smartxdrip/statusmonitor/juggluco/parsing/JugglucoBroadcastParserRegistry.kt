package com.metaguru.smartxdrip.statusmonitor.juggluco.parsing

import android.content.Intent

class JugglucoBroadcastParserRegistry(
    private val parsers: List<JugglucoBroadcastParser> = listOf(
        GlucodataMinuteParser(),
        XdripLocalBroadcastParser(),
        PatchedLibreBroadcastParser(),
        EverSenseBroadcastParser()
    )
) {
    fun parse(intent: Intent): JugglucoBroadcastParseResult? {
        val action = intent.action ?: return null
        return parsers.firstOrNull { it.canParse(action) }?.parse(intent)
    }
}
