# DebianExtension
A few Debian extensions

```
$ sudo -E core/install.sh
$ sudo -E xserver/install.sh
$ sudo chown -R $USER:$USER $HOME
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

wireless aliases
```
$ echo "alias wu=\"sudo \$DEBIAN_EXTENSION_HOME/core/network/wireless/wireless_up.sh {ni_name} {ssid}\"" >> $HOME/.local/aliases
```

`apt-get` install no recommends
```
$ echo "alias agi=\"sudo apt-get install --no-install-recommends\"" >> $HOME/.local/aliases
```

monitor
```
$ echo "exec --no-startup-id /usr/bin/xrandr -s 2560x1440 -r 144" >> $HOME/.config/i3/config
```
