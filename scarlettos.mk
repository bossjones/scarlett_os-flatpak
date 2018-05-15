# build-only: Don't do the cleanup and finish stages, which is useful if you want to build more things into the app
# flatpak-builder [OPTION…] DIRECTORY MANIFEST - Build manifest
.PHONY: run-build-scarlettos-force
run-build-scarlettos-force:
	@printf "=======================================\n"
	@printf "\n"
	@printf "$$GREEN $@$$NC\n"
	@printf "\n"
	@printf "=======================================\n"
	flatpak-builder \
	--force-clean \
	--disable-cache \
	--delete-build-dirs \
	-v \
	--user \
	--repo=scarlett_os-repo \
	scarlett_os-repo \
	org.scarlett.ScarlettOS.json ; \

# build-only: Don't do the cleanup and finish stages, which is useful if you want to build more things into the app
# flatpak-builder [OPTION…] DIRECTORY MANIFEST - Build manifest
.PHONY: run-build-scarlettos
run-build-scarlettos:
	@printf "=======================================\n"
	@printf "\n"
	@printf "$$GREEN $@$$NC\n"
	@printf "\n"
	@printf "=======================================\n"
	flatpak-builder \
	--force-clean \
	-v \
	--user \
	--repo=scarlett_os-repo \
	scarlett_os-repo \
	org.scarlett.ScarlettOS.json

# build-only: Don't do the cleanup and finish stages, which is useful if you want to build more things into the app
# flatpak-builder [OPTION…] DIRECTORY MANIFEST - Build manifest
.PHONY: run-build-scarlettos-build-only
run-build-scarlettos-build-only:
	@printf "=======================================\n"
	@printf "\n"
	@printf "$$GREEN $@$$NC\n"
	@printf "\n"
	@printf "=======================================\n"
	flatpak-builder \
	--force-clean \
	-v \
	--user \
	--repo=scarlett_os-repo \
	scarlett_os-repo \
	org.scarlett.ScarlettOS.json

# flatpak-remote-add — Add a remote repository
# SOURCE: http://docs.flatpak.org/en/latest/flatpak-command-reference.html#flatpak-remote-add
# flatpak remote-add [OPTION...] [--from] NAME LOCATION
.PHONY: add-new-repository-scarlettos
add-new-repository-scarlettos:
	@printf "=======================================\n"
	@printf "\n"
	@printf "$$GREEN $@$$NC\n"
	@printf "\n"
	@printf "=======================================\n"
	flatpak -v \
		--user remote-add \
		--no-gpg-verify \
		--if-not-exists \
		scarlett_os-repo \
		scarlett_os-repo

.PHONY: remove-repository-scarlettos
remove-repository-scarlettos:
	@printf "=======================================\n"
	@printf "\n"
	@printf "$$GREEN $@$$NC\n"
	@printf "\n"
	@printf "=======================================\n"
	flatpak -v \
		--user \
		remote-delete \
		--force \
		scarlett_os-repo ; \
	flatpak remotes ; \
	[[ -d scarlett_os-repo ]] && true || rm -rfv scarlett_os-repo ; \

# SOURCE: http://docs.flatpak.org/en/latest/flatpak-command-reference.html#flatpak-install
.PHONY: install-the-app-scarlettos
install-the-app-scarlettos:
	@printf "=======================================\n"
	@printf "\n"
	@printf "$$GREEN $@$$NC\n"
	@printf "\n"
	@printf "=======================================\n"
	flatpak -v \
		--user install \
		scarlett_os-repo \
		org.scarlett.ScarlettOS

.PHONY: check-app-installed-scarlettos
check-app-installed-scarlettos:
	@printf "=======================================\n"
	@printf "\n"
	@printf "$$GREEN $@$$NC\n"
	@printf "\n"
	@printf "=======================================\n"
	flatpak info org.scarlett.ScarlettOS

.PHONY: run-app-scarlettos
run-app-scarlettos:
	@printf "=======================================\n"
	@printf "\n"
	@printf "$$GREEN $@$$NC\n"
	@printf "\n"
	@printf "=======================================\n"
	flatpak run -v org.scarlett.ScarlettOS

# REBUILD SCARLETT
rebuild-scarlettos: prepare-repo-scarlettos run-build-scarlettos update-repo-scarlettos add-new-repository-scarlettos install-the-app-scarlettos check-app-installed-scarlettos

rebuild-scarlettos-force: prepare-repo-scarlettos run-build-scarlettos-force update-repo-scarlettos add-new-repository-scarlettos install-the-app-scarlettos check-app-installed-scarlettos

# Debug failing flatpak-build eg. why doesn't the tree command work
.PHONY: run-flatpak-builder-debug-scarlettos
run-flatpak-builder-debug-scarlettos:
	@printf "=======================================\n"
	@printf "\n"
	@printf "$$GREEN $@$$NC\n"
	@printf "\n"
	@printf "=======================================\n"
	flatpak-builder --run scarlett_os-repo org.scarlett.ScarlettOS.json bash

.PHONY: update-repo-scarlettos
update-repo-scarlettos:
	@printf "=======================================\n"
	@printf "\n"
	@printf "$$GREEN $@$$NC\n"
	@printf "\n"
	@printf "=======================================\n"
	flatpak build-update-repo \
	--prune \
	--prune-depth=20 \
	--generate-static-deltas \
	scarlett_os-repo ; \
	echo 'gpg-verify-summary=false' >> ./scarlett_os-repo/config ; \

.PHONY: prepare-repo-scarlettos
prepare-repo-scarlettos:
	@printf "=======================================\n"
	@printf "\n"
	@printf "$$GREEN $@$$NC\n"
	@printf "\n"
	@printf "=======================================\n"
	[[ -d scarlett_os-repo ]] || ostree init --mode=archive-z2 --repo=scarlett_os-repo ; \
	[[ -d scarlett_os-repo/refs/remotes ]] || mkdir -p scarlett_os-repo/refs/remotes && touch scarlett_os-repo/refs/remotes/.gitkeep ; \

# _all: prepare-repo install-deps build update-repo

# _prepare-repo:
# 	[[ -d repo ]] || ostree init --mode=archive-z2 --repo=repo
# 	[[ -d repo/refs/remotes ]] || mkdir -p repo/refs/remotes && touch repo/refs/remotes/.gitkeep

# _install-deps:
# 	flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
# 	flatpak --user install flathub org.freedesktop.Platform/x86_64/1.6 org.freedesktop.Sdk/x86_64/1.6
# 	flatpak --user remote-add --no-gpg-verify --if-not-exists electron https://vrutkovs.github.io/io.atom.electron.BaseApp/electron.flatpakrepo
# 	flatpak --user install electron io.atom.electron.BaseApp

# _build:
# 	flatpak-builder --force-clean --ccache --require-changes --repo=repo \
# 		--subject="Signal Desktop `date`" \
# 		${EXPORT_ARGS} app org.signal.Desktop.json

# _update-repo:
# 	flatpak build-update-repo --prune --prune-depth=20 --generate-static-deltas repo
# 	echo 'gpg-verify-summary=false' >> repo/config
