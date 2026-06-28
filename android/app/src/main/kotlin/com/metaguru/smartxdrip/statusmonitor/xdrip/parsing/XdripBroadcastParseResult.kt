package com.metaguru.smartxdrip.statusmonitor.xdrip.parsing

data class XdripBroadcastParseResult(
    val atMs: Long,
    val glucose: Double?,
    val unit: String?,
    val slopeName: String?,
    val slope: Double?,
    val sourceAction: String
)
