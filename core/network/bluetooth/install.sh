#!/bin/bash

echo 'Install bluetooth...'

apt-get install --no-install-recommends -y pulseaudio-module-bluetooth || exit 21
mkdir -p /etc/bluetooth/
cp ./debian/etc/bluetooth/main.conf /etc/bluetooth/main.conf || exit 22

echo 'Install bluetooth success.'
