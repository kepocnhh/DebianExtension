#!/bin/bash

for it in DEBIAN_EXTENSION_HOME HOME; do
 if [ ! -d "${!it}" ]; then echo "Dir $it does not exist!"; exit 11; fi; done

ISSUER=sublime

LATEST_VERSIONS="$(curl -s --max-time 2 https://www.sublimetext.com/download \
 | grep '>Build [0-9]' \
 | grep -Po '(?<=<h3>Build )[1-9][0-9]+(?=</h3>)' \
 | sort -V)"
if test $? -ne 0; then
 echo "Get latest versions $ISSUER error!"; exit 12
elif test -z "$LATEST_VERSIONS"; then
 echo "Latest versions $ISSUER is empty!"; exit 13
fi

ISSUER_VERSION=""
echo "
Latest versions:
$LATEST_VERSIONS

Enter $ISSUER version:"
while : ; do
 read -n1 char
 if test -z $char; then
  echo; break
 elif test $char == $'\x7f'; then
  if [ ! -z "$ISSUER_VERSION" ]; then
   ISSUER_VERSION="${ISSUER_VERSION:0:((${#ISSUER_VERSION} - 1))}"
   echo -en "\r\033[0K$ISSUER_VERSION"
  fi
 else
  ISSUER_VERSION+=$char
 fi
done

MACHINE_HARDWARE_NAME="$(/usr/bin/uname -m)"

for it in ISSUER_VERSION MACHINE_HARDWARE_NAME; do
 if test -z "${!it}"; then echo "$it is empty!"; exit 21; fi; done

if test -d "/opt/sublime-$ISSUER_VERSION"; then
 echo "${ISSUER^} $ISSUER_VERSION exists!"; exit 22
fi

case "$MACHINE_HARDWARE_NAME" in
 'x86_64') DISTRIBUTION='x64';;
 *) echo "Distribution $MACHINE_HARDWARE_NAME is not supported!"; exit 23;;
esac

BASE_URL="https://download.sublimetext.com"

echo "Download $ISSUER key..."
FILE="sublimehq-pub.gpg"
rm /tmp/$FILE
curl -f "$BASE_URL/$FILE" -o /tmp/$FILE && gpg --import /tmp/$FILE || exit 31
rm /tmp/$FILE

echo "Download $ISSUER ${ISSUER_VERSION}..."
FILE="sublime_text_build_${ISSUER_VERSION}_${DISTRIBUTION}.tar.xz"
rm /tmp/$FILE
curl -f "$BASE_URL/$FILE" -o /tmp/$FILE
if test $? -ne 0; then
 echo "Download $ISSUER error!"; exit 32
fi

echo "Download $ISSUER $ISSUER_VERSION signature..."
rm /tmp/${FILE}.asc
curl -f "$BASE_URL/${FILE}.asc" -o /tmp/${FILE}.asc
if test $? -ne 0; then
 echo "Download $ISSUER $ISSUER_VERSION signature error!"; exit 32
fi

gpg --verify /tmp/${FILE}.asc /tmp/$FILE || exit 33
rm /tmp/${FILE}.asc

echo "Unzip $ISSUER ${ISSUER_VERSION}..."
rm -rf /tmp/sublime_text
tar -xf /tmp/$FILE -C /tmp
if test $? -ne 0; then
 echo "Unzip $ISSUER $ISSUER_VERSION error!"; exit 41
fi
rm /tmp/$FILE

echo "Install $ISSUER ${ISSUER_VERSION}..."
mv /tmp/sublime_text "/opt/sublime-$ISSUER_VERSION"
if test $? -ne 0; then
 echo "Install $ISSUER $ISSUER_VERSION error!"; exit 42
fi

RESULT_PATH=$HOME/.config/sublime-text/Packages/User/
mkdir -p $RESULT_PATH
cp $DEBIAN_EXTENSION_HOME/xserver/desktop/config/sublime/* $RESULT_PATH
if test $? -ne 0; then
 echo "Install $ISSUER config error!"; exit 43
fi

/opt/sublime-${ISSUER_VERSION}/sublime_text --version
if test $? -ne 0; then
 echo "Running $ISSUER $ISSUER_VERSION error!"; exit 44
fi
