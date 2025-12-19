allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// Ensure Android subprojects (including plugins from pub cache) have a compileSdk set
subprojects {
    val defaultCompileSdk = 33

    fun resolveAppCompileSdk(): Int? {
        val appProject = rootProject.findProject(":app") ?: return null
        val androidExt = appProject.extensions.findByName("android") ?: return null
        return try {
            // Try common getters/fields via reflection to avoid compile-time dependency on AGP types
            val klass = androidExt.javaClass
            try { // getter getCompileSdk()
                val getter = klass.getMethod("getCompileSdk")
                (getter.invoke(androidExt) as? Int)
            } catch (e: NoSuchMethodException) {
                try { // field compileSdk
                    val field = klass.getDeclaredField("compileSdk")
                    field.isAccessible = true
                    field.getInt(androidExt)
                } catch (e2: NoSuchFieldException) {
                    try { // getter getCompileSdkVersion()
                        val getter2 = klass.getMethod("getCompileSdkVersion")
                        (getter2.invoke(androidExt) as? Int)
                    } catch (e3: Exception) {
                        null
                    }
                }
            }
        } catch (e: Exception) { null }
    }

    fun setCompileSdkForAndroidExtension(extAny: Any, sdk: Int) {
        try {
            val klass = extAny.javaClass
            try {
                val setter = klass.getMethod("setCompileSdk", Int::class.java)
                setter.invoke(extAny, sdk)
                return
            } catch (e: NoSuchMethodException) {}

            try {
                val setter2 = klass.getMethod("setCompileSdkVersion", Int::class.java)
                setter2.invoke(extAny, sdk)
                return
            } catch (e: NoSuchMethodException) {}

            try {
                val field = klass.getDeclaredField("compileSdk")
                field.isAccessible = true
                field.setInt(extAny, sdk)
                return
            } catch (e: NoSuchFieldException) {}

            try {
                val method = klass.methods.firstOrNull { it.name == "compileSdkVersion" }
                method?.invoke(extAny, sdk)
                return
            } catch (e: Exception) {}
        } catch (e: Exception) {}
    }

    // For Android library projects (e.g. plugins)
    plugins.withId("com.android.library") {
        extensions.findByName("android")?.let { androidExt ->
            val sdk = resolveAppCompileSdk() ?: defaultCompileSdk
            setCompileSdkForAndroidExtension(androidExt, sdk)
        }
    }

    // For Android application projects (if any)
    plugins.withId("com.android.application") {
        extensions.findByName("android")?.let { androidExt ->
            val sdk = resolveAppCompileSdk() ?: defaultCompileSdk
            setCompileSdkForAndroidExtension(androidExt, sdk)
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
