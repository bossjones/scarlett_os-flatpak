.PHONY: add-new-repository all bootstrap-runtime-system bootstrap-runtime-user build build-commit build-force build-local build-push build-push-local build-push-two-phase build-push-two-phase-force build-two-phase build-two-phase-force check-app-installed delet-remotes delete-remotes docker-shell full-setup-base install-flatpak-system-deps install-gnome-2.6-runtime install-gpg-keys install-runtime install-runtime-system install-runtime-user install-the-app list push push-force push-local rebuild-base remote-add remote-add-system remote-add-user run-app run-build run-flatpak-builder-base-bash run-flatpak-builder-debug-base run-flatpak-builder-uninstall-base run-flatpak-debug-base step1 step2 step3 step4 step5 tag tag-local travis

SHELL := $(shell which bash)

DIR   := $(shell basename $$PWD)

RED=\033[0;31m
GREEN=\033[0;32m
ORNG=\033[38;5;214m
BLUE=\033[38;5;81m
NC=\033[0m

export RED
export GREEN
export NC
export ORNG
export BLUE

export PATH := ./bin:./venv/bin:$(PATH)

username := scarlettos
container_name := scarlett_os-flatpak
docker_developer_chroot := .docker-developer

GIT_BRANCH    = $(shell git rev-parse --abbrev-ref HEAD)
GIT_SHA       = $(shell git rev-parse HEAD)
BUILD_DATE    = $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")
VERSION       = latest
NON_ROOT_USER = developer


IMAGE_TAG           := $(username)/$(container_name):$(GIT_SHA)
IMAGE_TAG_TEST      := $(username)/$(container_name)-systemd:$(GIT_SHA)
CONTAINER_NAME      := $(shell echo -n $(IMAGE_TAG) | openssl dgst -sha1 | sed 's/^.* //'  )
CONTAINER_NAME_TEST := $(shell echo -n $(username)/$(container_name)-systemd:$(GIT_SHA) | openssl dgst -sha1 | sed 's/^.* //'  )
FIXUID              := $(shell id -u)
FIXGID              := $(shell id -g)

LOCAL_REPOSITORY = $(HOST_IP):5000

TAG ?= $(VERSION)
ifeq ($(TAG),@branch)
	override TAG = $(shell git symbolic-ref --short HEAD)
	@echo $(value TAG)
endif

# verify that certain variables have been defined off the bat
check_defined = \
    $(foreach 1,$1,$(__check_defined))
__check_defined = \
    $(if $(value $1),, \
      $(error Undefined $1$(if $(value 2), ($(strip $2)))))

list_allowed_args := interface

info:
	echo -e "$(username)/$(container_name):$(GIT_SHA)\n"

list:
	@$(MAKE) -qp | awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$$)/ {split($$1,A,/ /);for(i in A)print A[i]}' | sort

##################################################[Docker CI]##################################################
# FIXME: Implement this
build-two-phase: build
	time docker run \
	--privileged \
	-i \
	-e TRACE=1 \
	--cap-add=ALL \
	--tty \
	--name $(CONTAINER_NAME) \
	-v $(PWD):/home/$(NON_ROOT_USER) \
	--entrypoint "bash" \
	$(IMAGE_TAG) \
	/home/developer/.ci/flatpak-bootstrap.sh

# Commit backend Container
	time docker commit --message "Makefile docker CI dep install for $(username)/$(container_name)" $(CONTAINER_NAME) $(IMAGE_TAG)
	time docker commit --message "Makefile docker CI dep install for $(username)/$(container_name)" $(CONTAINER_NAME) $(username)/$(container_name):latest

#################################################################

build-two-phase-force: build-force
	time docker run \
	--privileged \
	-i \
	-e TRACE=1 \
	--cap-add=ALL \
	--tty \
	--name $(CONTAINER_NAME) \
	-v $(PWD):/home/$(NON_ROOT_USER) \
	--entrypoint "bash" \
	$(IMAGE_TAG) \
	/home/developer/.ci/flatpak-bootstrap.sh

# Commit backend Container
	time docker commit --message "Makefile docker CI dep install for $(username)/$(container_name)" $(CONTAINER_NAME) $(IMAGE_TAG)
	time docker commit --message "Makefile docker CI dep install for $(username)/$(container_name)" $(CONTAINER_NAME) $(username)/$(container_name):latest

# Commit backend Container
build-commit:
	time docker commit --message "Makefile docker CI dep install for $(username)/$(container_name)" $(CONTAINER_NAME) $(IMAGE_TAG)

build:
	docker build --tag $(username)/$(container_name):$(GIT_SHA) ./.ci ; \
	docker tag $(username)/$(container_name):$(GIT_SHA) $(username)/$(container_name):latest
	docker tag $(username)/$(container_name):$(GIT_SHA) $(username)/$(container_name):$(TAG)

build-force:
	docker build --rm --force-rm --pull --no-cache -t $(username)/$(container_name):$(GIT_SHA) ./.ci ; \
	docker tag $(username)/$(container_name):$(GIT_SHA) $(username)/$(container_name):latest
	docker tag $(username)/$(container_name):$(GIT_SHA) $(username)/$(container_name):$(TAG)

build-local:
	docker build --tag $(username)/$(container_name):$(GIT_SHA) ./.ci ; \
	docker tag $(username)/$(container_name):$(GIT_SHA) $(LOCAL_REPOSITORY)/$(username)/$(container_name):latest

tag-local:
	docker tag $(username)/$(container_name):$(GIT_SHA) $(LOCAL_REPOSITORY)/$(username)/$(container_name):$(TAG)
	docker tag $(username)/$(container_name):$(GIT_SHA) $(LOCAL_REPOSITORY)/$(username)/$(container_name):latest

push-local:
	docker push $(LOCAL_REPOSITORY)/$(username)/$(container_name):$(TAG)
	docker push $(LOCAL_REPOSITORY)/$(username)/$(container_name):latest

build-push-local: build-local tag-local push-local

build-push-two-phase: build-two-phase tag push

build-push-two-phase-force: build-two-phase-force tag push

tag:
	docker tag $(username)/$(container_name):$(GIT_SHA) $(username)/$(container_name):latest
	docker tag $(username)/$(container_name):$(GIT_SHA) $(username)/$(container_name):$(TAG)

build-push: build tag
	docker push $(username)/$(container_name):latest
	docker push $(username)/$(container_name):$(GIT_SHA)
	docker push $(username)/$(container_name):$(TAG)

push:
	docker push $(username)/$(container_name):latest
	docker push $(username)/$(container_name):$(GIT_SHA)
	docker push $(username)/$(container_name):$(TAG)

pull:
	docker pull $(username)/$(container_name):latest

push-force: build-force push

docker-shell:
	docker exec -ti $(username)/$(container_name):latest /bin/bash

docker-build-systemd-test:
	docker build \
		--build-arg HOST_USER_ID=$(FIXUID) \
		--build-arg HOST_GROUP_ID=$(FIXGID) \
		-t $(username)/$(container_name)-systemd:$(GIT_SHA) \
		-f .ci/Dockerfile.systemd \
		./.ci ; \
	docker tag $(username)/$(container_name)-systemd:$(GIT_SHA) $(username)/$(container_name)-systemd:latest ; \
	docker tag $(username)/$(container_name)-systemd:$(GIT_SHA) $(username)/$(container_name)-systemd:$(TAG)

docker-build-systemd-test-force:
	docker build --rm --force-rm --pull --no-cache -t $(username)/$(container_name)-systemd:$(GIT_SHA) -f .ci/Dockerfile.systemd ./.ci ; \
	docker tag $(username)/$(container_name)-systemd:$(GIT_SHA) $(username)/$(container_name)-systemd:latest ; \
	docker tag $(username)/$(container_name)-systemd:$(GIT_SHA) $(username)/$(container_name)-systemd:$(TAG)

docker-run-systemd-test: docker-build-systemd-test
	time docker run \
	--privileged \
	-i \
	-e TRACE=1 \
	-e HOST_USER_ID=$(FIXUID) \
	-e HOST_GROUP_ID=$(FIXGID) \
	--cap-add=ALL \
	--security-opt seccomp=unconfined \
	--tmpfs /run \
	--tmpfs /run/lock \
	-v /sys/fs/cgroup:/sys/fs/cgroup:ro \
	-v $(PWD):/home/$(NON_ROOT_USER):rw \
	-d \
	--tty \
	--entrypoint "/usr/sbin/init" \
	--name $(CONTAINER_NAME_TEST) \
	$(IMAGE_TAG_TEST) true

	docker exec --tty \
	--privileged \
	-u $(NON_ROOT_USER) \
	-w /home/$(NON_ROOT_USER) \
	$(CONTAINER_NAME_TEST) env TERM=xterm bash .ci/ci-entrypoint.sh


docker-run-systemd-test-force: docker-build-systemd-test-force
	time docker run \
	--privileged \
	-i \
	-e TRACE=1 \
	--cap-add=ALL \
	--security-opt seccomp=unconfined \
	--tmpfs /run \
	--tmpfs /run/lock \
	-v /sys/fs/cgroup:/sys/fs/cgroup:ro \
	-v $(PWD):/home/$(NON_ROOT_USER) \
	-d \
	--tty \
	--entrypoint "/usr/sbin/init" \
	--name $(CONTAINER_NAME_TEST) \
	$(IMAGE_TAG_TEST) true

	docker exec --tty \
	--privileged \
	-u $(NON_ROOT_USER) \
	-w /home/$(NON_ROOT_USER) \
	$(CONTAINER_NAME_TEST) env TERM=xterm bash .ci/ci-entrypoint.sh

docker-exec-test-bash:
	docker exec -i -t \
	--privileged \
	-u $(NON_ROOT_USER) \
	-w /home/$(NON_ROOT_USER) \
	$(CONTAINER_NAME_TEST) bash -l

# FIX: placeholder
travis: pull docker-run-systemd-test

############################################[Docker CI - END]##################################################

############################################[Flatpak - BEGIN]##################################################

remote-add-system:
	flatpak remote-add --no-gpg-verify --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	flatpak remote-add --no-gpg-verify --if-not-exists gnome https://sdk.gnome.org/gnome.flatpakrepo

remote-add-user:
	flatpak --user remote-add --no-gpg-verify --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	flatpak --user remote-add --no-gpg-verify --if-not-exists gnome https://sdk.gnome.org/gnome.flatpakrepo

# Setup for both system and for user
remote-add: remote-add-user remote-add-system

bootstrap-runtime-user: remote-add-user install-runtime-user

bootstrap-runtime-system: remote-add-system remote-add-system

install-runtime-user:
# install gnome under user space
	flatpak --user install gnome org.gnome.Platform//3.22 || true
	flatpak --user install gnome org.gnome.Sdk//3.22 || true
	flatpak --user install gnome org.gnome.Platform//3.24 || true
	flatpak --user install gnome org.gnome.Sdk//3.24 || true
	flatpak --user install gnome org.gnome.Platform//3.26 || true
	flatpak --user install gnome org.gnome.Sdk//3.26 || true
# install freedesktop stuff under user space
	flatpak --user install gnome org.freedesktop.Sdk//1.4 || true
	flatpak --user install gnome org.freedesktop.Platform//1.4 || true
	flatpak --user install gnome org.freedesktop.Sdk//1.6 || true
	flatpak --user install gnome org.freedesktop.Platform//1.6 || true
	flatpak remotes
	flatpak --user remote-list --show-details
	flatpak --user list --runtime --show-details

install-runtime-system:
# install gnome globally
	flatpak install gnome org.gnome.Platform//3.22 || true
	flatpak install gnome org.gnome.Sdk//3.22 || true
	flatpak install gnome org.gnome.Platform//3.24 || true
	flatpak install gnome org.gnome.Sdk//3.24 || true
	flatpak install gnome org.gnome.Platform//3.26 || true
	flatpak install gnome org.gnome.Sdk//3.26 || true
# install freedesktop stuff globaly
	flatpak install gnome org.freedesktop.Sdk//1.4 || true
	flatpak install gnome org.freedesktop.Platform//1.4 || true
	flatpak install gnome org.freedesktop.Sdk//1.6 || true
	flatpak install gnome org.freedesktop.Platform//1.6 || true
	flatpak remotes
	flatpak remote-list --show-details
	flatpak list --runtime --show-details

install-gpg-keys:
	# Install the freedesktop 1.4 platform and SDK (runtime for building the app)
	# flatpak remote-add --if-not-exists gnome http://sdk.gnome.org/repo/
	curl -L 'https://sdk.gnome.org/keys/gnome-sdk.gpg' > /home/developer/gnome-sdk.gpg
	curl -L 'https://sdk.gnome.org/keys/gnome-sdk-autobuilder.gpg' > /home/developer/gnome-sdk-autobuilder.gpg

install-runtime: install-runtime-user install-runtime-system

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
# tree scarlett_os-base-repo

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

run-flatpak-builder-uninstall-base: run-flatpak-builder-debug-base

run-flatpak-builder-base-bash: run-flatpak-builder-debug-base

rebuild-base: step1 step2 step3 step4
############################################[Flatpak - END]##################################################
