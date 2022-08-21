from kepocnhh/debian-amd64:2

run apt-get update && apt-get upgrade -y && apt autoremove

arg PYTHON_VERSION

run apt-get install --no-install-recommends -y g++ make zlib1g-dev libncurses5-dev

run apt-get install --no-install-recommends -y gpg gpg-agent

run curl -f https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz -o /tmp/out
run curl -f https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz.asc -o /tmp/out.asc
run curl -f https://keybase.io/pablogsal/pgp_keys.asc -o /tmp/key \
 && gpg --import /tmp/key && rm /tmp/key
run gpg --verify /tmp/out.asc /tmp/out && rm /tmp/out.asc
run tar -xf /tmp/out -C /opt/ && rm /tmp/out

workdir /opt/Python-${PYTHON_VERSION}
run ./configure && make && make altinstall && ./python --version
