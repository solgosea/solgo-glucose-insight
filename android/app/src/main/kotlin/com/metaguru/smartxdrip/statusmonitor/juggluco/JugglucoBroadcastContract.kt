package com.metaguru.smartxdrip.statusmonitor.juggluco

object JugglucoBroadcastContract {
    const val ACTION_GLUCODATA_MINUTE = "glucodata.Minute"
    const val ACTION_XDRIP_BG_ESTIMATE = "com.eveningoutpost.dexdrip.BgEstimate"
    const val ACTION_PATCHED_LIBRE_GLUCOSE =
        "com.librelink.app.ThirdPartyIntegration.GLUCOSE_READING"
    const val ACTION_NS_EMULATOR = "com.eveningoutpost.dexdrip.NS_EMULATOR"

    const val FORMAT_GLUCODATA_MINUTE = "glucodataMinute"
    const val FORMAT_XDRIP_COMPATIBLE = "xdripCompatible"

    const val PATH_GLUCODATA = "glucodata"
    const val PATH_XDRIP_LOCAL = "xdripLocal"
    const val PATH_PATCHED_LIBRE = "patchedLibre"
    const val PATH_EVERSENSE = "eversense"
}
