import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystorePropertiesFile.reader(Charsets.UTF_8).use { reader ->
        keystoreProperties.load(reader)
    }
}
val hasReleaseKeystore =
    listOf("storeFile", "storePassword", "keyAlias", "keyPassword")
        .all { key -> keystoreProperties[key]?.toString()?.isNotBlank() == true } &&
        file(keystoreProperties["storeFile"].toString()).exists()

gradle.taskGraph.whenReady {
    val buildingReleaseArtifact = allTasks.any { task ->
        task.name.contains("Release", ignoreCase = true) &&
            (task.name.contains("assemble", ignoreCase = true) ||
                task.name.contains("bundle", ignoreCase = true) ||
                task.name.contains("package", ignoreCase = true))
    }
    if (buildingReleaseArtifact && !hasReleaseKeystore) {
        throw GradleException(
            "Release signing is not configured. Fill android/key.properties with storeFile, storePassword, keyAlias, and keyPassword. The storeFile path must exist."
        )
    }
}

android {
    namespace = "com.metaguru.smartxdrip"
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.metaguru.smartxdrip"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storePassword = keystoreProperties["storePassword"] as String?
            val releaseStoreFile = keystoreProperties["storeFile"] as String?
            if (!releaseStoreFile.isNullOrBlank()) {
                storeFile = file(releaseStoreFile)
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}
