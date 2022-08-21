# DebianExtension
A few Debian extensions

```
$ sudo -E core/install.sh
$ sudo -E xserver/install.sh
$ sudo chown -R $USER:$USER $HOME
$ echo ". \$HOME/.local/aliases" >> $HOME/.bashrc
$ echo ". \$HOME/.local/environment" >> $HOME/.bashrc
```

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
