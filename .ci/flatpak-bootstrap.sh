#!/usr/bin/env bash

# SOURCE: https://github.com/ghjnut/docker-steamcmd/blob/2f409cbd7e841b2f910c34c26df10f81fa9d408f/bin/build_auth
[[ "$TRACE" ]] && set -x

cd ..

# ---------------------------------------------
# Install Flatpak Remotes And Runtimes
# ---------------------------------------------
make bootstrap-runtime-user
