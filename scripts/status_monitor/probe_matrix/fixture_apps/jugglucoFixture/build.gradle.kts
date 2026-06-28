plugins {
    id("com.android.application")
}

android {
    namespace = "tk.glucodata"
    compileSdk = 36

    defaultConfig {
        applicationId = "tk.glucodata"
        minSdk = 23
        targetSdk = 36
        versionCode = 900001
        versionName = "probe-fixture"
    }
}
