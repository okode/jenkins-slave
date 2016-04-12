Requirements
============

Environment variables
---------------------

Create the following environment variables

    OKODE_CRASHLYTICS_BUILD_SECRET

For that, create a new file /Library/LaunchDaemons/setenv.OKODE_CRASHLYTICS_BUILD_SECRET.plist:

    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
      <key>Label</key>
      <string>setenv.OKODE_CRASHLYTICS_BUILD_SECRET</string>
      <key>ProgramArguments</key>
      <array>
        <string>/bin/launchctl</string>
        <string>setenv</string>
        <string>OKODE_CRASHLYTICS_BUILD_SECRET</string>
        <string>*** PUT HERE YOUR CRASHLYTICS BUILD SECRET ***</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>ServiceIPC</key>
      <false/>
    </dict>
    </plist>

Reboot to apply changes.

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

Ignore the following files adding them to your .gitignore:

    xcuserdata
    *.xcworkspace
    Pods
    Podfile.lock
    .gradle
    build
    compile_commands.json

Generate Xcode workspace processing Cocoapods dependencies:

    $ pod install

Set the following signing configuration:

    Code Signing Identity > Debug: iOS Developer
                          > Release: iPhone Distribution
    
    Provisioning Profile  > Debug: Automatic
                          > Release: Okode Enterprise Provisioning

Open the generated workspace and ensure your iOS project is configured
for generating DWARF with dSYM File for all configurations.

Generate a shared scheme and add that scheme to SCM.

Add a custom build phase for Run Script:

    "${PODS_ROOT}/Fabric/run" <Crashlytics API Key> <Crashlytics Build Secret>

Run the project and follow Fabric App wizard steps. Ensure the App is registered in Crashlytics before
submitting betas.
