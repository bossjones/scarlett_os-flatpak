#!/usr/bin/env bash

# SOURCE: https://github.com/ghjnut/docker-steamcmd/blob/2f409cbd7e841b2f910c34c26df10f81fa9d408f/bin/build_auth
[[ "$TRACE" ]] && set -x

# Load utility bash functions
_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $_DIR/shared_functions

[[ ! -d /var/run/dbus ]] && sudo mkdir /var/run/dbus

export LANG=C.UTF-8
export HISTCONTROL=ignoredups
export XDG_DATA_DIRS=/home/developer/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:/usr/local/share:/usr/share
export NON_ROOT_USER=developer
export TERM=xterm-256color
export PATH=/usr/lib64/ccache:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export HISTSIZE=1000000
export TRACE=1

printf "\n"
printf ${green}"Start dbus-daemon --system"${neutral}
printf "\n"
sudo dbus-daemon --system --fork

printf "\n"
printf ${green}"Run dbus-launch"${neutral}
printf "\n"
_DBUS_LAUNCH_OUTPUT=($(dbus-launch))

export $_DBUS_LAUNCH_OUTPUT

printf "\n"
printf ${green}"Create ~/.dbusrc"${neutral}
printf "\n"
env | grep -i DBUS_SESSION_BUS_ADDRESS > ~/.dbusrc
sed -i "s,^,export ,g" ~/.dbusrc
echo 'export DBUS_SYSTEM_BUS_ADDRESS="${DBUS_SESSION_BUS_ADDRESS}"' >> ~/.dbusrc

printf "\n"
printf ${green}"Dump ~/.dbusrc"${neutral}
printf "\n"
cat ~/.dbusrc

source ~/.dbusrc

# exec make rebuild-base
# exec ./ci/rebuild-base.sh

printf "\n"
printf ${green}"Run CI Tests"${neutral}
printf "\n"
make rebuild-base
