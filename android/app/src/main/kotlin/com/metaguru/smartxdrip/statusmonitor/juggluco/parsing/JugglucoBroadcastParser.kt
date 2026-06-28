package com.metaguru.smartxdrip.statusmonitor.juggluco.parsing

import android.content.Intent

interface JugglucoBroadcastParser {
    fun canParse(action: String): Boolean
    fun parse(intent: Intent, nowMs: Long = System.currentTimeMillis()): JugglucoBroadcastParseResult?
}

internal fun normalizeTimestamp(value: Long): Long {
    return if (value < 10_000_000_000L) value * 1000 else value
}

internal fun firstString(vararg values: Any?): String? {
    return values.firstNotNullOfOrNull { value ->
        value?.toString()?.trim()?.takeIf { it.isNotEmpty() }
    }
}

internal fun firstLong(vararg values: Any?): Long? {
    return values.firstNotNullOfOrNull { value ->
        when (value) {
            is Number -> value.toLong()
            is String -> value.trim().toLongOrNull()
            else -> null
        }
    }
}

internal fun firstDouble(vararg values: Any?): Double? {
    return values.firstNotNullOfOrNull { value ->
        when (value) {
            is Number -> value.toDouble()
            is String -> value.trim().toDoubleOrNull()
            else -> null
        }
    }
}
