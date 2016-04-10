Gradle iOS template
===================

Add the following files to your iOS project and to the SCM:

* Podfile
* build.gradle
* gradle.properties

Customize the following required properties in gradle.properties:

    TARGET_NAME
    CRASHLYTICS_API_KEY
    CRASHLYTICS_BUILD_SECRET

Run the following command (you will need Gradle installed in your system):

    $ gradle wrapper

Add the following files to the SCM:

* gradlew
* gradlew.bat
* gradle folder (including .jar and .properties)

Ensure your iOS project is configured for generating DWARF with dSYM File for all configurations

Add a custom build phase for Run Script:

    "${PODS_ROOT}/Fabric/run" <Crashlytics API Key> <Crashlytics Build Secret>

Run the project and follow Fabric App wizard steps. Ensure the App is registered in Crashlytics before
submitting betas.
