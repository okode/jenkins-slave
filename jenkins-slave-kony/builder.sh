#!/bin/bash

function loadDefaultVars {
    echo -ne "#> Loading default values..."
    source $(dirname $1)/vars.cfg
    echo -e "[OK]"
}

function change_line {
    local OLD_LINE_PATTERN=$1; shift
    local NEW_LINE=$1; shift
    local FILE=$1

    local NEW=$(echo "${NEW_LINE}" | escape_slashes)
    sed -i .bak '/'"${OLD_LINE_PATTERN}"'/s/.*/'"${NEW}"'/' "${FILE}"
    mv "${FILE}.bak" /tmp/
}

function dumpVars {

    echo -e "\n\n####### DUMP #######"
    echo -e "Target:"
    echo -e "Android phone: ${_target_android_phone}"
    echo -e "Android tablet: ${_target_android_tablet}"
    echo -e "iOS phone: ${_target_ios_phone}"
    echo -e "iOS tablet: ${_target_ios_tablet}"
    echo -e ""
    echo -e "Paths:"
    echo -e "Temporal path: ${_tmp}"
    echo -e "Workspace path: ${_workspace}"
    echo -e "Eclipse equinox path: ${_eclipse_equinox}"
    echo -e "Template project path: ${_template_project}"
    echo -e "Android SDK path: ${_android_sdk}"
    echo -e "Zipalign bin path: ${_android_zipalign}"
    echo -e "Ant bin path: ${_ant_bin}"
    echo -e ""
    echo -e "iOS Signing:"
    echo -e "Identity: ${_ios_code_sign_identity}"
    echo -e "uuid: ${_ios_provisioning_profile_uuid}"
    echo -e "name: ${_ios_provisioning_profile_name}"
    echo -e ""
    echo -e "Android Signing: "
    echo -e "Storepass: ${_android_storepass}"
    echo -e "Keyalias: ${_android_keyalias}"
    echo -e "Keypass: ${_android_keypass}"
    echo -e "Keystore: ${_android_keystore}"
    echo -e "####### END #######\n\n"
}

function cleanUp {
    echo -ne "#> Cleaning up temporal folder..."
    rm -fr ${_tmp} 2>/dev/null
    mkdir -p ${_tmp}
    echo -e "[OK]"
}

function checkVars {
    if [[ -z ${_tmp} ]];then
        echo -e "[ERROR]: Path folder is not defined. Use --tmp /path/to/tmp/folder to add it"
        exit 1
    fi

    if [[ -z ${_workspace} ]];then
        echo -e "[ERROR]: Workspace folder is not defined. Use -w|--workspace /path/to/w/folder to add it"
        exit 1
    fi

    if [[ -z ${_eclipse_equinox} ]];then
        echo -e "[ERROR]: Equinox plugin path is not defined. Use --eqiunox /path/to/equinox/jar to add it"
        exit 1
    elif [[  ! -f ${_eclipse_equinox} ]]; then
        echo -e "[ERROR]: Equinox ${_eclipse_equinox} not exists."
        exit 1
    fi

    if [[ -z ${_template_project} ]];then
        echo -e "[ERROR]: Template plugin path is not defined. Use --template /path/to/template/jar to add it"
        exit 1
    elif [[  ! -f ${_template_project} ]]; then
        echo -e "[ERROR]: Template ${_template_project} not exists."
        exit 1
    fi

    if [[ -z ${_android_sdk} ]];then
        echo -e "[ERROR]: Android home  path is not defined. Use --android-sdk /path/to/android/sdk to add it"
        exit 1
    elif [[  ! -d ${_android_sdk} ]]; then
        echo -e "[ERROR]: Android sdk path ${_android_sdk} not exists."
        exit 1
    fi

    if [[ -z ${_android_zipalign} ]];then
        echo -e "[ERROR]: Android zipalign  path is not defined. Use --android-sdk /path/to/zipalign/bin to add it"
        exit 1
    elif [[  ! -f ${_android_zipalign} ]]; then
        echo -e "[ERROR]: zipalign bin path ${_android_zipalign} not exists."
        exit 1
    fi

    if [[ -z ${_ant_bin} ]];then
        echo -e "[ERROR]: Android zipalign  path is not defined. Use --android-sdk /path/to/ant/bin to add it"
        exit 1
    elif [[  ! -f ${_ant_bin} ]]; then
        echo -e "[ERROR]: ant bin path ${_ant_bin} not exists."
        exit 1
    fi

    if [[ ${_target_android_phone} == "false" && ${_target_android_tablet} == "false" &&
        ${_target_ios_phone} == "false" && ${_target_ios_tablet} == "false" ]]; then
        echo -e "[ERROR]: No target defined."
        exit 1
    fi
}

function extractTemplateJAR {
    echo -ne "Generating template zip..."
    mkdir -p ${_tmp}/template
    unzip ${_template_project} -d ${_tmp}/template
    find ${_tmp}/template/* ! -name '*.zip' -type f -exec rm -f {} +
    find ${_tmp}/template/* ! -name '*.zip' -type d -exec rm -fr {} +
    if [[ ! -f ${_tmp}/template/iOS-GA*.zip ]];then
        echo -e "[ERROR]: Error getting template zip project."
    #    exit 1
    fi
    _template_project_zip=${_tmp}/template/iOS-GA.zip
}

function injectingProperties {
    echo "# injecting properties"

    change_line "^android=" "android=${_target_android_phone}" ${_workspace}/build.properties
    change_line "^androidtablet=" "androidtablet=${_target_android_tablet}" ${_workspace}/build.properties
    change_line "^iphone=" "iphone=${_target_ios_phone}" ${_workspace}/build.properties
    change_line "^ipad=" "ipad=${_target_ios_tablet}" ${_workspace}/build.properties

    #change_line "^android.home=" "android.home=${_android_sdk}" ${_workspace}/global.properties
    #change_line "^eclipse.equinox.path=" "eclipse.equinox.path=${_eclipse_equinox}" ${_workspace}/global.properties

    #change_line "^httpport=" "httpport=$_middleware_httpport" middleware.properties
    #change_line "^httpsport=" "httpsport=$_middleware_httpsport" middleware.properties
    #change_line "^ipaddress=" "ipaddress=$_middleware_ipaddress" middleware.properties
}
function build {
    echo "## Execute Kony Ant Build - Start ##"
    export PATH=$PATH:${_ant_bin_dir}
    ant -file build.xml
    echo "## Execute Kony Ant Build - Done ##"
    echo ''
}

function postBuildAndroid {
    if [[ ${_target_android_phone} == "true" -o  ${_target_android_tablet} == "true" ]]; then
        set +x
        echo "## Execute Android signing APK - Start ##"
        cd binaries/android

        if [[ ! -z ${_android_storepass} && ${_android_storepass} != "" &&
            ! -z ${_android_keyalias} && ${_android_keyalias} != "" &&
            ! -z ${_android_keypass} && ${_android_keypass} != "" &&
            ! -z ${_android_keystore} && ${_android_keystore} != "" && ]]; then

                jarsigner -storepass "${_android_storepass}" -keypass "${_android_keypass}" -keystore ../../${_android_keystore} luavmandroid.apk ${_android_keyalias} -signedjar luavmandroid-signed_unaligned.apk
                ${_android_zipalign} -v 4 luavmandroid-signed_unaligned.apk luavmandroid-signed.apk
        fi
        cd -
        echo "## Execute Android signing APK - Done ##"
        echo ''
    fi

}

loadDefaultVars $0
dumpVars
checkVars
cleanUp
extractTemplateJAR
injectingProperties
build
