#!/usr/bin/env bash

[[ ! -d /var/run/dbus ]] && sudo mkdir /var/run/dbus

sudo dbus-daemon --system --fork

_DBUS_LAUNCH_OUTPUT=($(dbus-launch))

export $_DBUS_LAUNCH_OUTPUT

env | grep -i DBUS_SESSION_BUS_ADDRESS > ~/.dbusrc
sed -i "s,^,export ,g" ~/.dbusrc
echo 'export DBUS_SYSTEM_BUS_ADDRESS="${DBUS_SESSION_BUS_ADDRESS}"' >> ~/.dbusrc

cat ~/.dbusrc

source ~/.dbusrc

exec make rebuild-base
