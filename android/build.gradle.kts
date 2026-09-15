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
fun Project.forceCompileSdk(compile: Int) {
    if (!hasProperty("android")) return
    runCatching {
        val android = extensions.getByName("android")
        val method = android.javaClass.getMethod("compileSdkVersion", Int::class.javaObjectType)
        method.invoke(android, compile)
    }.recoverCatching {
        val android = extensions.getByName("android")
        val method = android.javaClass.getMethod("setCompileSdk", Int::class.javaObjectType)
        method.invoke(android, compile)
    }
}

subprojects {
    if (project.state.executed) {
        forceCompileSdk(36)
    } else {
        project.afterEvaluate {
            forceCompileSdk(36)
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
