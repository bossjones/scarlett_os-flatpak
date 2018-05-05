remote-add:
	flatpak remote-add --no-gpg-verify --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	flatpak remote-add --no-gpg-verify --if-not-exists gnome https://sdk.gnome.org/gnome.flatpakrepo
	flatpak --user remote-add --no-gpg-verify --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	flatpak --user remote-add --no-gpg-verify --if-not-exists gnome https://sdk.gnome.org/gnome.flatpakrepo

install-runtime:
	# Install the freedesktop 1.4 platform and SDK (runtime for building the app)
	# flatpak remote-add --if-not-exists gnome http://sdk.gnome.org/repo/
	wget -P /home/developer https://sdk.gnome.org/keys/gnome-sdk.gpg
	wget -P /home/developer https://sdk.gnome.org/keys/gnome-sdk-autobuilder.gpg
# install gnome under user space
	flatpak --user install gnome org.gnome.Platform//3.22 || true
	flatpak --user install gnome org.gnome.Sdk//3.22 || true
	flatpak --user install gnome org.gnome.Platform//3.24 || true
	flatpak --user install gnome org.gnome.Sdk//3.24 || true
# install gnome globally
	flatpak install gnome org.gnome.Platform//3.22 || true
	flatpak install gnome org.gnome.Sdk//3.22 || true
	flatpak install gnome org.gnome.Platform//3.24 || true
	flatpak install gnome org.gnome.Sdk//3.24 || true
# install freedesktop stuff under user space
	flatpak --user install gnome org.freedesktop.Sdk//1.4 || true
	flatpak --user install gnome org.freedesktop.Platform//1.4 || true
	flatpak --user install gnome org.freedesktop.Sdk//1.6 || true
	flatpak --user install gnome org.freedesktop.Platform//1.6 || true
# install freedesktop stuff globaly
	flatpak install gnome org.freedesktop.Sdk//1.4 || true
	flatpak install gnome org.freedesktop.Platform//1.4 || true
	flatpak install gnome org.freedesktop.Sdk//1.6 || true
	flatpak install gnome org.freedesktop.Platform//1.6 || true
	flatpak remotes
	flatpak --user remote-list --show-details
	flatpak --user list --runtime --show-details
	flatpak remote-list --show-details
	flatpak list --runtime --show-details

install-gnome-2.6-runtime:
	flatpak --user install gnome org.gnome.Platform//3.26 || true
	flatpak --user install gnome org.gnome.Sdk//3.26 || true
	flatpak remotes
	flatpak --user remote-list --show-details
	flatpak --user list --runtime --show-details
	flatpak remote-list --show-details
	flatpak list --runtime --show-details

delete-remotes:
	flatpak remotes
	flatpak --user remote-delete --force gnome || true
	flatpak --user remote-delete --force flathub || true
	flatpak remote-delete --force gnome || true
	flatpak remote-delete --force flathub || true

install-flatpak-system-deps:
	sudo dnf install flatpak-devel flatpak-builder flatpak-runtime-config wget git bzip2 elfutils make ostree -y

############################################################
# Tutorial starts here
############################################################

run-build:
# flatpak-builder --repo=scarlett_os-base-repo scarlett_os-base org.scarlett.ScarlettOSBase.json
	flatpak-builder --force-clean -v --user --repo=scarlett_os-base-repo scarlett_os-base org.scarlett.ScarlettOSBase.json
# display contents of dictonary dir

# flatpak-remote-add — Add a remote repository
# SOURCE: http://docs.flatpak.org/en/latest/flatpak-command-reference.html#flatpak-remote-add
# flatpak remote-add [OPTION...] [--from] NAME LOCATION
add-new-repository:
	flatpak -v --user remote-add --no-gpg-verify --if-not-exists scarlett_os-base-repo scarlett_os-base-repo
# display contants of scarlett_os-base-repo dir
	tree scarlett_os-base-repo

# flatpak-install — Install an application or runtime
# flatpak install [OPTION...] REMOTE-NAME REF...
# SOURCE: http://docs.flatpak.org/en/latest/flatpak-command-reference.html#flatpak-install
install-the-app:
	flatpak -v --user install scarlett_os-base-repo org.scarlett.ScarlettOSBase

check-app-installed:
	@echo -e "\n"
	flatpak info org.scarlett.ScarlettOSBase
	@echo -e "\n"

run-app:
	flatpak run org.scarlett.ScarlettOSBase

all: run-build add-new-repository install-the-app check-app-installed run-app

step1: run-build
step2: add-new-repository
step3: install-the-app
step4: check-app-installed
step5: run-app

# If you want to do everything in one step, do this
full-setup-base: install-flatpak-system-deps delet-remotes remote-add install-runtime install-gnome-2.6-runtime step1 step2 step3 step4 step5

# Debug successfully built flatpak
run-flatpak-debug-base:
	flatpak run -d --command=bash org.scarlett.ScarlettOSBase

# Debug failing flatpak-build
run-flatpak-builder-debug-base:
	flatpak-builder --run scarlett_os-base org.scarlett.ScarlettOSBase.json bash

# [developer@gnometop scarlett_os-flatpak]$ flatpak-builder --run --help
# Usage:
#   flatpak-builder [OPTION…] DIRECTORY MANIFEST COMMAND [args] - Run command in build sandbox

# Help Options:
#   -h, --help                              Show help options
#   --help-all                              Show all help options

# Application Options:
#   -v, --verbose                           Print debug information during command processing
#   --arch=ARCH                             Architecture to build for (must be host compatible)
#   --run                                   Run a command in the build directory
#   --log-session-bus                       Log session bus calls
#   --log-system-bus                        Log system bus calls
#   --ccache                                Use ccache
#   --share=SHARE                           Share with host
#   --unshare=SHARE                         Unshare with host
#   --socket=SOCKET                         Expose socket to app
#   --nosocket=SOCKET                       Don't expose socket to app
#   --device=DEVICE                         Expose device to app
#   --nodevice=DEVICE                       Don't expose device to app
#   --allow=FEATURE                         Allow feature
#   --disallow=FEATURE                      Don't allow feature
#   --filesystem=FILESYSTEM[:ro]            Expose filesystem to app (:ro for read-only)
#   --nofilesystem=FILESYSTEM               Don't expose filesystem to app
#   --env=VAR=VALUE                         Set environment variable
#   --own-name=DBUS_NAME                    Allow app to own name on the session bus
#   --talk-name=DBUS_NAME                   Allow app to talk to name on the session bus
#   --system-own-name=DBUS_NAME             Allow app to own name on the system bus
#   --system-talk-name=DBUS_NAME            Allow app to talk to name on the system bus
#   --add-policy=SUBSYSTEM.KEY=VALUE        Add generic policy option
#   --remove-policy=SUBSYSTEM.KEY=VALUE     Remove generic policy option
#   --persist=FILENAME                      Persist home directory

# [developer@gnometop scarlett_os-flatpak]$

run-flatpak-builder-uninstall-base: run-flatpak-builder-debug-base

base-rebuild: step1 step2 step3 step4
