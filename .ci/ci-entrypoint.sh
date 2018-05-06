#!/usr/bin/env bash

# SOURCE: https://github.com/ghjnut/docker-steamcmd/blob/2f409cbd7e841b2f910c34c26df10f81fa9d408f/bin/build_auth
[[ "$TRACE" ]] && set -x

[[ ! -d /var/run/dbus ]] && sudo mkdir /var/run/dbus

export LANG=C.UTF-8
export HISTCONTROL=ignoredups
export XDG_DATA_DIRS=/home/developer/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:/usr/local/share:/usr/share
export NON_ROOT_USER=developer
export TERM=xterm-256color
export PATH=/usr/lib64/ccache:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export HISTSIZE=1000000
export TRACE=1

sudo dbus-daemon --system --fork

_DBUS_LAUNCH_OUTPUT=($(dbus-launch))

export $_DBUS_LAUNCH_OUTPUT

env | grep -i DBUS_SESSION_BUS_ADDRESS > ~/.dbusrc
sed -i "s,^,export ,g" ~/.dbusrc
echo 'export DBUS_SYSTEM_BUS_ADDRESS="${DBUS_SESSION_BUS_ADDRESS}"' >> ~/.dbusrc

cat ~/.dbusrc

source ~/.dbusrc

exec make rebuild-base
