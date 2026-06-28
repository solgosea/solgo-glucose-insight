package com.metaguru.smartxdrip.statusmonitor.juggluco.parsing

data class JugglucoBroadcastParseResult(
    val atMs: Long,
    val glucose: Double?,
    val unit: String?,
    val path: String,
    val format: String,
    val message: String?
)
