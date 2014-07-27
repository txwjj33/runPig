#!/bin/bash

ant clean

OS_NAME=`uname -o`

APPNAME="run"
if [ -z "$BUILD_TYPE" ]; then
    BUILD_TYPE=release
fi
VERBOSE=0

usage(){
cat << EOF
usage: $0 [options]

Build apk C/C++ code for $APPNAME using Android NDK

OPTIONS:
-v  Verbose mode.
-h	this help
EOF
}

BUILD_NATIVE_ARGS=
NDK_DEBUG=

while getopts "dvh" OPTION; do
case "$OPTION" in
d)
BUILD_TYPE=debug
NDK_DEBUG=1
;;
v)
VERBOSE=1
BUILD_NATIVE_ARGS="$BUILD_NATIVE_ARGS V=1"
;;
h)
usage
exit 0
;;
\?)
# Suppress warning
;;
esac
done

echo "Build Type: $BUILD_TYPE"
BUILD_NATIVE_ARGS="$BUILD_NATIVE_ARGS BUILD_TYPE=$BUILD_TYPE NDK_DEBUG=$NDK_DEBUG"
APK_ARGS="$BUILD_TYPE copy_final_file"

. build_native.sh $BUILD_NATIVE_ARGS

LIBFILE=libs/armeabi/libgame.so
SYMFILE=obj/local/armeabi/libgame.so

if [ ! -f "$LIBFILE" ]; then
	echo "Failed to build native code, please review your code."
	exit 1
fi

echo "Keeping Symbolic version: $SYMFILE"
cp "$SYMFILE" "$APK_OUTPUT_DIR/symbols/libgame-$REVISION-$BUILD_TYPE.so"

echo "====================================================================================================Building Android apk..."

APK_ARGS="$APK_ARGS -Dbuild.number=$REVISION"
if [ "Cygwin" = "$OS_NAME" ]; then
    APK_ARGS="$APK_ARGS -Dapk.output.dir=`cygpath -w $APK_OUTPUT_DIR`"
else
    APK_ARGS="$APK_ARGS -Dapk.output.dir=$APK_OUTPUT_DIR"
fi

APK_ARGS="$APK_ARGS -Dapp.name=$APPNAME"

echo "=========APK_ARGS: $APK_ARGS"

ant $APK_ARGS

# disable proguard
#if [ "release" = "$BUILD_TYPE" ]; then
#	cp "bin/proguard/mapping.txt" "$APK_OUTPUT_DIR/symbols/mapping-$REVISION-$BUILD_TYPE.txt"
#fi
