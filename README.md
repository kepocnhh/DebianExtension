# DebianExtension
A few Debian extensions

![version](https://img.shields.io/static/v1?label=version&message=0.2.1&labelColor=212121&color=2962ff&style=flat)

---

### Phase #1

```
$ ./DebianExtension/download/download_wlan_packages.sh
$ cp -r ./DebianExtension /usb/{debian}/
$ cp -r $HOME/Downloads/wlan /usb/{debian}/
```

```
# mkdir /tmp/usb
# mount /dev/{sdN} /tmp/usb
# cp -r /tmp/usb/{debian} /home/{username}/.tmp
# umount /dev/{sdN}
# cd /home/{username}/.tmp
# cp ./DebianExtension/debian/etc/apt/sources.list /etc/apt/sources.list
# ./DebianExtension/core/network/wireless/install_wlan.sh
# systemctl reboot
```

```
# cd /home/{username}/.tmp
# ./DebianExtension/core/network/wireless/wpa_supplicant_conf_create.sh {SSID}
# ./DebianExtension/core/network/wireless/wireless_up.sh {SSID}
# /usr/bin/apt-get update
# ./DebianExtension/install.sh -t {version}
# apt-get install sudo
# /usr/sbin/usermod -aG sudo {username}
# exit
```

---

### Phase #2

```
$ cd /opt/DebianExtension-{version}
$ sudo -E ./core/install.sh
$ sudo -E ./xserver/install.sh
$ sudo chown -R $USER:$USER $HOME
$ echo ". \$HOME/.local/aliases" >> $HOME/.bashrc
$ echo ". \$HOME/.local/environment" >> $HOME/.bashrc
```

---

### Phase #3

xserver on idle suspend
```
$ echo "$USER $HOSTNAME=NOPASSWD:/usr/bin/systemctl suspend" | sudo tee -a /etc/sudoers.d/$USER
```

auto mount on
```
$ sudo mkdir /etc/environment.d
$ echo "MOUNT_AUTO=true" | sudo tee -a /etc/environment.d/systemd.env
```

wireless alias
```
$ echo "alias wu=\"sudo \$DEBIAN_EXTENSION_HOME/core/network/wireless/wireless_up.sh {ni_name} {ssid}\"" >> $HOME/.local/aliases
```

`apt-get` no install recommends alias
```
$ echo "alias agi=\"sudo apt-get install --no-install-recommends\"" >> $HOME/.local/aliases
```

monitor
```
$ echo "/usr/bin/xrandr -s 2560x1440 -r 144" >> $HOME/.xsessionrc
```
