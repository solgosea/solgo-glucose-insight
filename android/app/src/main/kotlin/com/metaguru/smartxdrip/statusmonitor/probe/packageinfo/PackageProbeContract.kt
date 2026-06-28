package com.metaguru.smartxdrip.statusmonitor.probe.packageinfo

object PackageProbeContract {
    const val CHANNEL = "com.metaguru.smartxdrip/status_probe_package"
    const val METHOD_QUERY = "query"

    const val ARG_PACKAGE_NAME = "packageName"
    const val FIELD_PACKAGE_NAME = "packageName"
    const val FIELD_VISIBLE = "visible"
    const val FIELD_INSTALLED = "installed"
    const val FIELD_VERSION_NAME = "versionName"
    const val FIELD_VERSION_CODE = "versionCode"
    const val FIELD_CHECKED_AT_MS = "checkedAtMs"
    const val FIELD_ERROR = "error"
}
