Requirements
============

Environment variables
---------------------

Create the following environment variables

    OKODE_CRASHLYTICS_BUILD_SECRET

For that, create a new file ~/LaunchAgents/com.okode.environment.plist:

    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>KeepAlive</key>
        <false/>
        <key>Label</key>
        <string>com.okode.environment</string>
        <key>ProgramArguments</key>
        <array>
            <string>/bin/sh</string>
            <string>/etc/environment.rc</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WatchPaths</key>
        <array>
            <string>/etc/environment.rc</string>
        </array>
    </dict>
    </plist>

And ensure you have the following contents in /etc/environment.rc:

    launchctl setenv OKODE_CRASHLYTICS_BUILD_SECRET [CRASHLYTICS_BUILD_SECRET]

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

Add a custom build phase for Run Script (replace the API Key if needed):

    "${PODS_ROOT}/Fabric/run" 51a920f68611292bc387b86e9ffa20553d095372 ${OKODE_CRASHLYTICS_BUILD_SECRET}

Run the project and follow Fabric App wizard steps. Ensure the App is registered in Crashlytics before
submitting betas.
