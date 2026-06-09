plugins {
    id("com.android.library")
}

group = "com.pmorales.gemini_nano_android"
version = "1.0-SNAPSHOT"

android {
    namespace = "com.pmorales.gemini_nano_android"

    compileSdk = 36

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    sourceSets {
        getByName("main") {
            java.srcDirs("src/main/kotlin")
        }
        getByName("test") {
            java.srcDirs("src/test/kotlin")
        }
    }

    defaultConfig {
        minSdk = 24
    }

    testOptions {
        unitTests {
            isIncludeAndroidResources = true
            all {
                it.useJUnitPlatform()

                it.outputs.upToDateWhen { false }

                it.testLogging {
                    events("passed", "skipped", "failed", "standardOut", "standardError")
                    showStandardStreams = true
                }
            }
        }
    }
}



dependencies {
    testImplementation("org.jetbrains.kotlin:kotlin-test")
    testImplementation("org.mockito:mockito-core:5.0.0")
}
