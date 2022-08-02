# DebianExtension
A few Debian extensions

```
$ sudo -E core/install.sh
$ sudo -E xserver/install.sh
$ sudo chown -R $USER $HOME
```

xserver on idle suspend
```
$ echo "$USER $HOSTNAME=NOPASSWD:/usr/bin/systemctl suspend" | sudo tee -a /etc/sudoers.d/$USER
```

auto mount on
```
$ echo "MOUNT_AUTO=true" | sudo tee -a /etc/environment.d/systemd.env
```
