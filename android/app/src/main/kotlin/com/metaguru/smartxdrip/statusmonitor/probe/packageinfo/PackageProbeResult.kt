package com.metaguru.smartxdrip.statusmonitor.probe.packageinfo

data class PackageProbeResult(
    val packageName: String,
    val visible: Boolean,
    val installed: Boolean,
    val versionName: String?,
    val versionCode: Long?,
    val checkedAtMs: Long,
    val error: String? = null,
) {
    fun toMap(): Map<String, Any?> = mapOf(
        PackageProbeContract.FIELD_PACKAGE_NAME to packageName,
        PackageProbeContract.FIELD_VISIBLE to visible,
        PackageProbeContract.FIELD_INSTALLED to installed,
        PackageProbeContract.FIELD_VERSION_NAME to versionName,
        PackageProbeContract.FIELD_VERSION_CODE to versionCode,
        PackageProbeContract.FIELD_CHECKED_AT_MS to checkedAtMs,
        PackageProbeContract.FIELD_ERROR to error,
    )
}
