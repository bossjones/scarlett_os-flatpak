#!/usr/bin/env bash

# SOURCE: https://github.com/ghjnut/docker-steamcmd/blob/2f409cbd7e841b2f910c34c26df10f81fa9d408f/bin/build_auth
[[ "$TRACE" ]] && set -x

#######################################################
# step1
#######################################################
echo "-------------------------------------
step 1
-------------------------------------"

flatpak-builder --force-clean -v --user --repo=scarlett_os-base-repo scarlett_os-base org.scarlett.ScarlettOSBase.json

#######################################################
# step2
#######################################################
echo "-------------------------------------
step 2
-------------------------------------"

flatpak -v --user remote-add --no-gpg-verify --if-not-exists scarlett_os-base-repo scarlett_os-base-repo
# display contants of scarlett_os-base-repo dir
tree scarlett_os-base-repo

#######################################################
# step3
#######################################################
echo "-------------------------------------
step 3
-------------------------------------"

flatpak -v --user install scarlett_os-base-repo org.scarlett.ScarlettOSBase

#######################################################
# step4
#######################################################
echo "-------------------------------------
step 4
-------------------------------------"

echo -e "\n"
flatpak info org.scarlett.ScarlettOSBase
echo -e "\n"

#######################################################
# step5
#######################################################
echo "-------------------------------------
step 5
-------------------------------------"

echo -e "\n"
flatpak info org.scarlett.ScarlettOSBase
echo -e "\n"
flatpak run org.scarlett.ScarlettOSBase
