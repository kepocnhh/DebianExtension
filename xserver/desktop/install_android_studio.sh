#!/bin/bash

if test $# -ne 2; then
  echo "Script needs for 2 arguments but actual $#!"; exit 11
fi

ANDROID_STUDIO_VERSION=$1
DISTRIBUTION=$2 # linux

for it in ANDROID_STUDIO_VERSION DISTRIBUTION; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 21; fi; done

for it in JAVA_HOME GRADLE_HOME ANDROID_HOME; do
 if [ ! -d "${!it}" ]; then echo "Dir $it does not exist!"; exit 22; fi; done

if test -d "/opt/google/android-studio-${ANDROID_STUDIO_VERSION}"; then
 echo "Android studio ${ANDROID_STUDIO_VERSION} exists!"; exit 23
fi

apt-get install --no-install-recommends -y libnss3 # emulator
if test $? -ne 0; then
 echo "Install lib error!"; exit 24
fi

case "$ANDROID_STUDIO_VERSION" in
 '2021.2.1.16') SHA_256='aa5773a9e1da25bdb2367a8bdd2b623dbe0345170ed231a15b3f40e8888447dc';;
 *) echo "Android studio version $ANDROID_STUDIO_VERSION is not supported!"; exit 31;;
esac

case "$DISTRIBUTION" in
 'linux') /bin/true;; # ignored
 *) echo "Android studio distribution $DISTRIBUTION is not supported!"; exit 32;;
esac

BASE_URL="https://redirector.gvt1.com/edgedl/android/studio/ide-zips/$ANDROID_STUDIO_VERSION"

echo "Download android studio ${ANDROID_STUDIO_VERSION}..."
FILE="android-studio-${ANDROID_STUDIO_VERSION}-${DISTRIBUTION}.tar.gz"
rm /tmp/$FILE
curl -f -L $BASE_URL/$FILE -o /tmp/$FILE
if test $? -ne 0; then
 echo "Download android studio error!"; exit 41
fi

echo "$SHA_256 /tmp/$FILE" | sha256sum -c || exit 42

echo "Unzip android studio ${ANDROID_STUDIO_VERSION}..."
rm -rf /tmp/android-studio
tar -xf /tmp/$FILE -C /tmp
if test $? -ne 0; then
 echo "Unzip android studio error!"; exit 51
fi

echo "Install android studio ${ANDROID_STUDIO_VERSION}..."
if [ ! -d /opt/google ]; then
 mkdir /opt/google || exit 1 # todo
fi
mv /tmp/android-studio "/opt/google/android-studio-${ANDROID_STUDIO_VERSION}"
if test $? -ne 0; then
 echo "Install android studio error!"; exit 52
fi
rm /tmp/$FILE

exit 0
