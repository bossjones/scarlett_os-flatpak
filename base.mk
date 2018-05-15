# ############################################################
# # Tutorial starts here
# ############################################################

# run-build:
# 	flatpak-builder --force-clean -v --user --repo=scarlett_os-base-repo scarlett_os-base org.scarlett.ScarlettOSBase.json

# # flatpak-remote-add — Add a remote repository
# # SOURCE: http://docs.flatpak.org/en/latest/flatpak-command-reference.html#flatpak-remote-add
# # flatpak remote-add [OPTION...] [--from] NAME LOCATION
# add-new-repository:
# 	flatpak -v --user remote-add --no-gpg-verify --if-not-exists scarlett_os-base-repo scarlett_os-base-repo

# # flatpak-install — Install an application or runtime
# # flatpak install [OPTION...] REMOTE-NAME REF...
# # SOURCE: http://docs.flatpak.org/en/latest/flatpak-command-reference.html#flatpak-install
# install-the-app:
# 	flatpak -v --user install scarlett_os-base-repo org.scarlett.ScarlettOSBase

# check-app-installed:
# 	@echo -e "\n"
# 	flatpak info org.scarlett.ScarlettOSBase
# 	@echo -e "\n"

# run-app:
# 	flatpak run org.scarlett.ScarlettOSBase

# all: run-build add-new-repository install-the-app check-app-installed run-app

# step1: run-build
# step2: add-new-repository
# step3: install-the-app
# step4: check-app-installed
# step5: run-app

# # If you want to do everything in one step, do this
# full-setup-base: install-flatpak-system-deps delet-remotes remote-add install-runtime install-gnome-2.6-runtime step1 step2 step3 step4 step5

# # Debug successfully built flatpak
# run-flatpak-debug-base:
# 	flatpak run -d --command=bash org.scarlett.ScarlettOSBase

# # Debug failing flatpak-build
# run-flatpak-builder-debug-base:
# 	flatpak-builder --run scarlett_os-base org.scarlett.ScarlettOSBase.json bash

# run-flatpak-builder-uninstall-base: run-flatpak-builder-debug-base

# run-flatpak-builder-base-bash: run-flatpak-builder-debug-base

# rebuild-base: step1 step2 step3 step4
