echo "download chrome..."

ERROR_CODE_EXTENSION_HOME=10
ERROR_CODE_DOWNLOAD=11
ERROR_CODE_INSTALL=21
ERROR_CODE_COPY=31

if test -z $DEBIAN_EXTENSION_HOME; then
    echo "Debian extension home path must be non-empty!"
    exit $ERROR_CODE_EXTENSION_HOME
fi

DOWNLOAD_URL=https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

TMP_FILE_PATH=/tmp/chrome.deb

curl -s "$DOWNLOAD_URL" -o "$TMP_FILE_PATH"
if test $? -ne 0; then
	echo "download chrome error!"
    exit $ERROR_CODE_DOWNLOAD
fi

echo "install chrome..."

apt install -y "$TMP_FILE_PATH"
if test $? -ne 0; then
    echo "install chrome error!"
    exit $ERROR_CODE_INSTALL
fi

rm $TMP_FILE_PATH

google-chrome-stable --version

cp $DEBIAN_EXTENSION_HOME/xserver/desktop/chrome.sh /usr/local/bin/chrome.sh
if test $? -ne 0; then
	echo "Copy chrome executable error!"
    exit $ERROR_CODE_COPY
fi

echo "install chrome success."

exit 0
