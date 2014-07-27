APPNAME="run"

# options

buildexternalsfromsource=

usage(){
cat << EOF
usage: $0 [options]

Build C/C++ code for $APPNAME using Android NDK

OPTIONS:
-s	Build externals from source
-h	this help
EOF
}

while getopts "sh" OPTION; do
case "$OPTION" in
s)
buildexternalsfromsource=1
;;
h)
usage
exit 0
;;
esac
done

# paths

if [ -z "${NDK_ROOT+aaa}" ];then
echo "please define NDK_ROOT"
exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# ... use paths relative to current directory

#export GAME_ROOT=$DIR/../../..
export QUICK=$DIR/../../..

COCOS2DX_ROOT="${QUICK}/lib/cocos2d-x"
APP_ROOT="$DIR/.."
APP_ANDROID_ROOT="$DIR"

echo "NDK_ROOT = $NDK_ROOT"
echo "QUICK = ${QUICK}"
echo "COCOS2DX_ROOT = $COCOS2DX_ROOT"
echo "APP_ROOT = $APP_ROOT"
echo "APP_ANDROID_ROOT = $APP_ANDROID_ROOT"

if [ ! -d "$APP_ANDROID_ROOT"/assets ]; then
    mkdir "$APP_ANDROID_ROOT"/assets
fi

# delete exist folder
if [ -d "$APP_ANDROID_ROOT"/assets/res ]; then
    rm -rf "$APP_ANDROID_ROOT"/assets/res
fi

if [ -d "$APP_ANDROID_ROOT"/assets/scripts ]; then
    rm -rf "$APP_ANDROID_ROOT"/assets/scripts
fi

# copy res
echo "copy res"
mkdir "$APP_ANDROID_ROOT"/assets/res
for file in "$APP_ROOT"/res
do
if [ -d "$file" -a "fonts" != "$file" ]; then
	cp -rf "$file" "$APP_ANDROID_ROOT"/assets
fi
done

# copy scripts
echo "copy scripts"
mkdir "$APP_ANDROID_ROOT"/assets/scripts
for file in "$APP_ROOT"/scripts
do
if [ -d "$file" -a "fonts" != "$file" ]; then
	cp -rf "$file" "$APP_ANDROID_ROOT"/assets
fi
done

# run ndk-build
if [[ "$buildexternalsfromsource" ]]; then
    echo "Building external dependencies from source"
    "$NDK_ROOT"/ndk-build -C "$APP_ANDROID_ROOT" $* \
        "NDK_MODULE_PATH=${COCOS2DX_ROOT}:${COCOS2DX_ROOT}/cocos2dx/platform/third_party/android/source"
else
    echo "Using prebuilt externals"
    "$NDK_ROOT"/ndk-build -C "$APP_ANDROID_ROOT" $* \
        "NDK_MODULE_PATH=${QUICK}:${COCOS2DX_ROOT}:${COCOS2DX_ROOT}/cocos2dx/platform/third_party/android/prebuilt"
fi
