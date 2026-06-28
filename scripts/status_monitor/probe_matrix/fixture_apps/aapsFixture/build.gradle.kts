plugins {
    id("com.android.application")
}

android {
    namespace = "info.nightscout.aapsclient"
    compileSdk = 36

    defaultConfig {
        applicationId = "info.nightscout.aapsclient"
        minSdk = 23
        targetSdk = 36
        versionCode = 900001
        versionName = "probe-fixture"
    }
}
