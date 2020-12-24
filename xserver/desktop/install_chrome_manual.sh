echo "download chrome..."

ERROR_CODE_DOWNLOAD=1
ERROR_CODE_INSTALL=2

DOWNLOAD_URL=https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

TMP_FILE_PATH=/tmp/chrome.deb

curl -s $DOWNLOAD_URL -o $TMP_FILE_PATH || STATUS=$?
if test $STATUS -ne 0; then
	echo "download chrome error!"
    exit $ERROR_CODE_DOWNLOAD
fi

echo "install chrome..."

apt install $TMP_FILE_PATH || STATUS=$?
if test $STATUS -ne 0; then
    echo "install chrome error!"
    exit $ERROR_CODE_INSTALL
fi

rm $TMP_FILE_PATH

google-chrome-stable --version

echo "install chrome success."

exit 0
