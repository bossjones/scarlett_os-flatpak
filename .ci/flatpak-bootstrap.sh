#!/usr/bin/env bash

# SOURCE: https://github.com/ghjnut/docker-steamcmd/blob/2f409cbd7e841b2f910c34c26df10f81fa9d408f/bin/build_auth
[[ "$TRACE" ]] && set -x

# grab sudo priviledges so we do not need to interrupt the following process if they are needed
# SOURCE: https://github.com/niccokunzmann/cp-docker-development/blob/212363005e107525bdbb9780508ec0d1b11b0f6c/docker/ubuntu/build/run_all.sh
# sudo true

# ---------------------------------------------
# Install Flatpak Remotes And Runtimes
# ---------------------------------------------
# make bootstrap-runtime-user

/home/developer/.ci/bootstrap-runtime-user
