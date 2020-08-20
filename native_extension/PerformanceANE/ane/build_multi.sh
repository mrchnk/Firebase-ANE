#!/bin/sh

#Get the path to the script and trim to get the directory.
pathtome=$0
pathtome="${pathtome%/*}"

PROJECTNAME=PerformanceANE
libSuffix="_LIB"

AIR_SDK="/Users/eoinlandy/SDKs/AIRSDK_33"

if [ ! -d "$pathtome/../../../native_library/apple/FirebaseANE/Build/Products/Release-iphonesimulator/" ]; then
echo "No Simulator build. Build using Xcode"
exit
fi

if [ ! -d "$pathtome/../../../native_library/apple/FirebaseANE/Build/Products/Release-iphoneos/" ]; then
echo "No Device build. Build using Xcode"
exit
fi

#Setup the directory.
echo "Making directories."

if [ ! -d "$pathtome/platforms" ]; then
mkdir "$pathtome/platforms"
fi
if [ ! -d "$pathtome/platforms/ios" ]; then
mkdir "$pathtome/platforms/ios"
fi
if [ ! -d "$pathtome/platforms/android" ]; then
mkdir "$pathtome/platforms/android"
fi
if [ ! -d "$pathtome/platforms/ios/simulator" ]; then
mkdir "$pathtome/platforms/ios/simulator"
fi
if [ ! -d "$pathtome/platforms/ios/simulator/Frameworks" ]; then
mkdir "$pathtome/platforms/ios/simulator/Frameworks"
fi
if [ ! -d "$pathtome/platforms/ios/device" ]; then
mkdir "$pathtome/platforms/ios/device"
fi
if [ ! -d "$pathtome/platforms/ios/device/Frameworks" ]; then
mkdir "$pathtome/platforms/ios/device/Frameworks"
fi
if [ ! -d "$pathtome/platforms/default" ]; then
mkdir "$pathtome/platforms/default"
fi

#Copy SWC into place.
cp "$pathtome/../bin/$PROJECTNAME.swc" "$pathtome/"

#Extract contents of SWC.
unzip "$pathtome/$PROJECTNAME.swc" "library.swf" -d "$pathtome"

#Copy library.swf to folders.
cp "$pathtome/library.swf" "$pathtome/platforms/android"
cp "$pathtome/library.swf" "$pathtome/platforms/ios/simulator"
cp "$pathtome/library.swf" "$pathtome/platforms/ios/device"
cp "$pathtome/library.swf" "$pathtome/platforms/default"

#Copy native libraries into place.
cp "$pathtome/../../../native_library/android/FirebaseANE/Performance/build/outputs/aar/Performance-release.aar" "$pathtome/platforms/android/app-release.aar"
unzip "$pathtome/platforms/android/app-release.aar" "classes.jar" -d "$pathtome/platforms/android"
unzip "$pathtome/platforms/android/app-release.aar" "res/*" -d "$pathtome/platforms/android"
mv "$pathtome/platforms/android/res" "$pathtome/platforms/android/com.tuarua.firebase.$PROJECTNAME-res"

cp -R -L "$pathtome/../../../native_library/apple/FirebaseANE/Build/Products/Release-iphonesimulator/lib$PROJECTNAME$libSuffix.a" "$pathtome/platforms/ios/simulator/lib$PROJECTNAME.a"
cp -R -L "$pathtome/../../../native_library/apple/FirebaseANE/Build/Products/Release-iphoneos/lib$PROJECTNAME$libSuffix.a" "$pathtome/platforms/ios/device/lib$PROJECTNAME.a"

cp -R -L "$pathtome/../../../firebase_frameworks/simulator/FirebasePerformance.framework" "$pathtome/platforms/ios/simulator/Frameworks"
cp -R -L "$pathtome/../../../firebase_frameworks/device/FirebasePerformance.framework" "$pathtome/platforms/ios/device/Frameworks"

cp -R -L "$pathtome/../../../firebase_frameworks/simulator/GTMSessionFetcher.framework" "$pathtome/platforms/ios/simulator/Frameworks"
cp -R -L "$pathtome/../../../firebase_frameworks/device/GTMSessionFetcher.framework" "$pathtome/platforms/ios/device/Frameworks"

cp -R -L "$pathtome/../../../firebase_frameworks/simulator/Protobuf.framework" "$pathtome/platforms/ios/simulator/Frameworks"
cp -R -L "$pathtome/../../../firebase_frameworks/device/Protobuf.framework" "$pathtome/platforms/ios/device/Frameworks"

#Run the build command.
echo "Building ANE."
"$AIR_SDK"/bin/adt -package \
-target ane "$pathtome/$PROJECTNAME.ane" "$pathtome/extension_multi.xml" \
-swc "$pathtome/$PROJECTNAME.swc" \
-platform iPhone-x86  -C "$pathtome/platforms/ios/simulator" "library.swf" "Frameworks" "lib$PROJECTNAME.a" \
-platformoptions "$pathtome/platforms/ios/platform.xml" \
-platform iPhone-ARM  -C "$pathtome/platforms/ios/device" "library.swf" "Frameworks" "lib$PROJECTNAME.a" \
-platformoptions "$pathtome/platforms/ios/platform.xml" \
-platform Android-x86 \
-C "$pathtome/platforms/android" "library.swf" "classes.jar" \
com.tuarua.firebase.${PROJECTNAME}-res/. \
-platformoptions "$pathtome/platforms/android/platform.xml" \
-platform Android-ARM \
-C "$pathtome/platforms/android" "library.swf" "classes.jar" \
com.tuarua.firebase.${PROJECTNAME}-res/. \
-platformoptions "$pathtome/platforms/android/platform.xml" \
-platform Android-ARM64 \
-C "$pathtome/platforms/android" "library.swf" "classes.jar" \
com.tuarua.firebase.${PROJECTNAME}-res/. \
-platformoptions "$pathtome/platforms/android/platform.xml" \
-platform default -C "$pathtome/platforms/default" "library.swf" \
-C "$pathtome/platforms/android" "AndroidManifest.xml" \
-C "$pathtome/platforms/ios" "Entitlements.entitlements" "InfoAdditions.plist"

cp "$pathtome/$PROJECTNAME.ane" "$pathtome/../../../example/extensions/$PROJECTNAME.ane"

#remove the frameworks from sim and device, as not needed any more
rm -r "$pathtome/platforms/ios/simulator"
rm -r "$pathtome/platforms/ios/device"
rm -r "$pathtome/platforms/default"
rm "$pathtome/platforms/android/classes.jar"
rm "$pathtome/platforms/android/app-release.aar"
rm "$pathtome/platforms/android/library.swf"
rm "$pathtome/$PROJECTNAME.swc"
rm "$pathtome/library.swf"
rm -r "$pathtome/platforms/android/com.tuarua.firebase.$PROJECTNAME-res"
echo "Finished."
