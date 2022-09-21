#!/bin/bash

for it in HOME JAVA_HOME GRADLE_HOME ANDROID_HOME; do
 if [ ! -d "${!it}" ]; then echo "Dir $it does not exist!"; exit 11; fi; done

ISSUER="android studio"

LATEST_VERSION="$(curl -s https://developer.android.com/studio/ \
 | grep -E '^\s+>android-studio-' \
 | grep -Po '(?<=>android-studio-)\S+(?=-linux.tar.gz</a>)')"
if test $? -ne 0; then
 echo "Get latest version $ISSUER error!"; exit 12
elif test -z "$LATEST_VERSION"; then
 echo "Latest version $ISSUER is empty!"; exit 13
fi

ISSUER_VERSION=""
echo "
Latest version: $LATEST_VERSION

Enter $ISSUER version:"
while : ; do
 read -n1 char
 if test -z $char; then
  echo; break
 else
  ISSUER_VERSION+=$char
 fi
done

DISTRIBUTION=linux

for it in ISSUER_VERSION DISTRIBUTION; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 21; fi; done

if test -d "$HOME/.local/google/android-studio"; then
 echo "${ISSUER^} exists!"; exit 22
fi

apt-get install --no-install-recommends -y libnss3 # emulator
if test $? -ne 0; then
 echo "Install lib error!"; exit 23
fi

case "$ISSUER_VERSION" in
 '2021.2.1.16') SHA_256='aa5773a9e1da25bdb2367a8bdd2b623dbe0345170ed231a15b3f40e8888447dc';;
 *) echo "${ISSUER^} version $ISSUER_VERSION is not supported!"; exit 31;;
esac

case "$DISTRIBUTION" in
 'linux') /bin/true;; # ignored
 *) echo "${ISSUER^} distribution $DISTRIBUTION is not supported!"; exit 32;;
esac

BASE_URL="https://redirector.gvt1.com/edgedl/android/studio/ide-zips/$ISSUER_VERSION"

echo "Download $ISSUER ${ISSUER_VERSION}..."
FILE="android-studio-${ISSUER_VERSION}-${DISTRIBUTION}.tar.gz"
rm /tmp/$FILE
curl -f -L $BASE_URL/$FILE -o /tmp/$FILE
if test $? -ne 0; then
 echo "Download $ISSUER $ISSUER_VERSION error!"; exit 41
fi

echo "$SHA_256 /tmp/$FILE" | sha256sum -c || exit 42

echo "Unzip $ISSUER ${ISSUER_VERSION}..."
if [ ! -d "$HOME/.local/google" ]; then
 mkdir "$HOME/.local/google" || exit 1 # todo
fi
rm -rf /tmp/android-studio
tar -xf /tmp/$FILE -C "$HOME/.local/google"
if test $? -ne 0; then
 echo "Unzip $ISSUER $ISSUER_VERSION error!"; exit 51
fi
rm /tmp/$FILE
