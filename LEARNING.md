# Notes on settings.conf

```
#!/usr/bin/env bash

# SOURCE: https://github.com/johnramsden/pathofexile-flatpak/blob/a5036e33616bc248f77d937c8c7363aaba0cb55d/settings.conf


# ---------------------------------------------------------------------------
# An invocation of flatpak-builder proceeds in these stages, each being specified in detail in json format in MANIFEST :

# Download all sources

# Initialize the application directory with flatpak build-init

# Build and install each module with flatpak build

# Clean up the final build tree by removing unwanted files and e.g. stripping binaries

# Finish the application directory with flatpak build-finish
# ---------------------------------------------------------------------------

################################################################################################
# flatpak build-init:
# Description
# Initializes a directory for building an application. DIRECTORY is the name of the directory. APPNAME is the application id of the app that will be built. SDK and RUNTIME specify the sdk and runtime that the application should be built against and run in.

# The result of this command is that a metadata file is created inside the given directory. Additionally, empty files and var subdirectories are created.

# It is an error to run build-init on a directory that has already been initialized as a build directory.
################################################################################################

################################################################################################
# flatpak-build:
# Runs a build command in a directory. DIRECTORY must have been initialized with flatpak build-init.

# The sdk that is specified in the metadata file in the directory is mounted at /usr and the files and var subdirectories are mounted at /app and /var, respectively. They are writable, and their contents are preserved between build commands, to allow accumulating build artifacts there.
################################################################################################

################################################################################################
# flatpak build-finish:
# Description
# Finalizes a build directory, to prepare it for exporting. DIRECTORY is the name of the directory.

# The result of this command is that desktop files, icons and D-Bus service files from the files subdirectory are copied to a new export subdirectory. In the metadata file, the command key is set in the [Application] group, and the supported keys in the [Environment] group are set according to the options.

# You should review the exported files and the application metadata before creating and distributing an application bundle.

# It is an error to run build-finish on a directory that has not been initialized as a build directory, or has already been finalized.
################################################################################################

# flatpak build-init [OPTION...] DIRECTORY APPNAME SDK RUNTIME [BRANCH]
# flatpak build [OPTION...] DIRECTORY [COMMAND [ARG...]]
# flatpak build-finish [OPTION...] DIRECTORY

# flatpak build-finish
# flatpak build-export

FLATPAK_NAME='ScarlettOS'
FLATPAK_DNS_PREFIX='org.scarlett'
FLATPAK_VERSION='0.1'
FLATPAK_RUNTIME='org.scarlettos.ScarlettOSNightly'
FLATPAK_RUNTIME_SDK='org.scarlettos.Sdk'
FLATPAK_RUNTIME_PLATFORM='org.scarlettos.Platform'
FLATPAK_REMOTE_NAME="scarlettrepo"
# Name of repo folder
FLATPAK_REMOTE_REPO="scarlettrepo"
FLATPAK_PATH_TO_REPO="scarlettos-repo"
FLATPAK_PATH_TO_BUILD="scarlettos-build"
FLATPAK_PATH_TO_STATE_DIR=".flatpak-builder"

# -----------------------------------------------------------------------------------------
# SOURCE: flatpak-latest/index.html#xdg-base-directories
# XDG base directories
# XDG base directories are a Freedesktop standard which defines standard locations where user-specific application data and configuration should be stored. If your application already respects these nothing must be changed.
# By default, Flatpak sets three XDG base directories that should be used by applications for user-specific storage. These are:
# -----------------------------------------------------------------------------------------
# XDG_CONFIG_HOME	User-specific configuration files	~/.var/app/<app-id>/config
# XDG_DATA_HOME	User-specific data	~/.var/app/<app-id>/data
# XDG_CACHE_HOME	Non-essential user-specific data	~/.var/app/<app-id>/cache
# -----------------------------------------------------------------------------------------
# User-specific configuration files
_FLATPAK_XDG_CONFIG_HOME="${HOME}/.var/app/${FLATPAK_DNS_PREFIX}.${FLATPAK_NAME}/config"
# User-specific data
_FLATPAK_XDG_DATA_HOME="${HOME}/.var/app/${FLATPAK_DNS_PREFIX}.${FLATPAK_NAME}/data"
# Non-essential user-specific data
_FLATPAK_XDG_CACHE_HOME="${HOME}/.var/app/${FLATPAK_DNS_PREFIX}.${FLATPAK_NAME}/cache"
# -----------------------------------------------------------------------------------------

# COMMANDS
# flatpak build-init $FLATPAK_PATH_TO_BUILD $FLATPAK_RUNTIME $FLATPAK_RUNTIME_SDK $FLATPAK_RUNTIME_PLATFORM $FLATPAK_VERSION

# XDG_DATA_HOME=$HOME/.local/share
# XDG_CONFIG_HOME=$HOME/.config
# XDG_CACHE_HOME=$HOME/.cache
# XDG_DATA_DIRS=/usr/local/share:/usr/share
# XDG_CONFIG_DIRS=/etc/xdg





# - DOCKER_REPO=johnramsden
#   - DOCKER_TAG=flatpakrepo
#   - DOCKER_IMAGE_VERSION=latest
#   - FLATPAK_GPG_KEY=2F8F3BAFE151AEAA5BF56EF26918091584F31AA2
#   - FLATPAK_GPG_HOMEDIR=gpg_homedir
#   - FLATPAK_GPG_KEYRING=flatpakrepo_keyring.gpg
#   - FLATPAK_REPO_NAME=johnramsden
#   - FLATPAK_REPO_URL=http://flatpakrepo.johnramsden.ca/johnramsden.flatpakrepo
#   - FLATPAK_LOCAL_REPO=docs/applications
#   - FLATPAK_STATE_DIR=flatpak_builder
#   - FLATPAK_GIT_REPO=git@github.com:johnramsden/flatpakrepo.git
#   - FLATPAK_WEBSITE_REPO=git@github.com:johnramsden/flatpakrepo.johnramsden.ca.git
#   - FLATPAK_RUNTIME=org.freedesktop.Platform/i386/1.6
#   - FLATPAK_SDK=org.freedesktop.Sdk/i386/1.6
#   - FLATPAK_REMOTE_NAME=flathub
#   - FLATPAK_REMOTE_REPO=https://flathub.org/repo/flathub.flatpakrepo
#   - SSH_FILE=flatpakrepo_rsa
#   - WEBSITE_DIR=docs
#   - WEBSITE_BRANCH=gh-pages
#   - COMMIT=${TRAVIS_COMMIT::8}

```


# webgtk

```
NOTE: MAKE BUILD LOOK LIKE THIS

export FLATPAK_BUILD=/path/to/flatpak-build
export WEBKITGTK_BUILD=/path/to/webkitgtk-source
export REPO=/path/to/webkitgtk-repo

flatpak build-init $FLATPAK_BUILD org.webkitgtk.WebKitGTKNightly org.webkitgtk.Sdk org.webkitgtk.Platform 0.1

flatpak build $FLATPAK_BUILD cmake -DPORT=GTK -DCMAKE_INSTALL_PREFIX=/app -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS_RELEASE="-O2 -DNDEBUG" -DCMAKE_CXX_FLAGS_RELEASE="-O2 -DNDEBUG" -DENABLE_MINIBROWSER=ON -DENABLE_INTROSPECTION=OFF $WEBKITGTK_BUILD
flatpak build $FLATPAK_BUILD make -C $WEBKITGTK_BUILD -j7
flatpak build $FLATPAK_BUILD make -C $WEBKITGTK_BUILD install

cp manifest.in $FLATPAK_BUILD
flatpak build-finish $FLATPAK_BUILD
flatpak build-export $REPO $FLATPAK_BUILD

# Install after initial export:

flatpak --user remote-add --no-gpg-verify --if-not-exists webkitgtk /path/to/webkitgtk-repo # can only be run once
flatpak --user install webkitgtk org.webkitgtk.WebKitGTKNightly

# Update after later exports:

flatpak update org.webkitgtk.WebKitGTKNightly

# Run

flatpak run org.webkitgtk.WebKitGTKNightly
```

source: https://github.com/zdobersek/flatpaks/blob/c8bbbc15863cef9f892eae5b79a4be48845b573e/webkitgtk-nightly/README.md
