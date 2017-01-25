#!/usr/bin/env bash

CURRENT_DIR=$(cd "$(dirname $0)" && pwd)

ensure_pakcages_folder_exist() {
    if [ ! -d "../unitypackages" ]; then
        mkdir "../unitypackages"
    fi
}

download_unity_package() {
    PACKAGE_NAME="$1"
    SAVE_PATH="../unitypackages/$PACKAGE_NAME"
    if [ ! -f "$SAVE_PATH" ]; then
        echo "Download $PACKAGE_NAME"
        curl -o "$SAVE_PATH" http://staging.sdkbox.com/installer/v1/"$PACKAGE_NAME"
    fi
}

import_unity_package() {
    PACKAGE_NAME="$1"
    SAVE_PATH="../unitypackages/$PACKAGE_NAME"
    /Applications/Unity/Unity.app/Contents/MacOS/Unity -projectPath $CURRENT_DIR -importPackage "$CURRENT_DIR/$SAVE_PATH"
}

test_unity_package() {
    UNITY_PACKAGE_NAME=$1
    # clean project
    echo "Git clean"
    git clean -dxf
    git checkout -f

    # download unity package
    echo "Download unity package if not exist"
    download_unity_package "$UNITY_PACKAGE_NAME"

    # import unity package
    echo "Import unity package: $UNITY_PACKAGE_NAME"
    import_unity_package "$UNITY_PACKAGE_NAME"
}

ensure_pakcages_folder_exist

test_unity_package "sdkboxreview.unitypackage"
test_unity_package "sdkboxsdkboxplay.unitypackage"

echo 'Done'
