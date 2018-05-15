#!/usr/bin/env bash

# SOURCE: https://github.com/ghjnut/docker-steamcmd/blob/2f409cbd7e841b2f910c34c26df10f81fa9d408f/bin/build_auth
[[ "$TRACE" ]] && set -x

# ca.johnramsden.flatpakrepo.version="0.1.3"

settings_config="settings.conf"

exit_unset(){
    echo "Unsetting environment variables and exiting with \"exit ${1}\""
    unset $(cat ${settings_config} | grep -v ^# | sed -E 's/(.*)=.*/\1/' | xargs)
    exit ${1}
}

install_runtimes(){
    # install-gpg-keys:
    curl -L 'https://sdk.gnome.org/keys/gnome-sdk.gpg' > /home/developer/gnome-sdk.gpg
    curl -L 'https://sdk.gnome.org/keys/gnome-sdk-autobuilder.gpg' > /home/developer/gnome-sdk-autobuilder.gpg

    # Add remotes
    flatpak --user remote-add --no-gpg-verify --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak --user remote-add --no-gpg-verify --if-not-exists gnome https://sdk.gnome.org/gnome.flatpakrepo

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
}

# build_init(){

# }

settings_export(){
    # cd "${1}"
    # Set environment variables from '${settings_config}' if it exists
    if [ -f "${settings_config}" ]; then
        export $(cat ${settings_config} | sed -e /^$/d -e /^#/d | xargs) || exit_unset 1
    fi
}

build_flatpak(){
    echo "Building ${1}"
    if [ -d "${1}" ]; then
        # cd "${1}"
        # Set environment variables from '${settings_config}' if it exists
        if [ -f "${settings_config}" ]; then
            export $(cat ${settings_config} | sed -e /^$/d -e /^#/d | xargs) || exit_unset 1
        fi

        # TODO: Replace above with settings_export function
        # settings_export

        # flatpak remote-add --user --no-gpg-verify --if-not-exists "${FLATPAK_REMOTE_NAME}" "${FLATPAK_REMOTE_REPO}"

        # NOTE: Disabled on purpose
        # flatpak install --user "${FLATPAK_REMOTE_NAME}" "${FLATPAK_RUNTIME}" "${FLATPAK_SDK}"

        install_runtimes

        # flatpak build-init [OPTION...] DIRECTORY APPNAME SDK RUNTIME [BRANCH]
        [ -d "${FLATPAK_NAME}" ] || echo "Creating build directory" && \
                                        flatpak build-init --user \
                                        ${FLATPAK_NAME} "${FLATPAK_DNS_PREFIX}.${FLATPAK_NAME}" \
                                        ${FLATPAK_RUNTIME} ${FLATPAK_SDK} || exit_unset 1

        # # XDG_CACHE_HOME: Where user-specific non-essential (cached) data should be written
        # mkdir -p ${HOME}/.cache/app/${FLATPAK_DNS_PREFIX}.${FLATPAK_NAME}
        # User-specific configuration files
        mkdir -p ${_FLATPAK_XDG_CONFIG_HOME}
        # User-specific data
        mkdir -p ${_FLATPAK_XDG_DATA_HOME}
        # Non-essential user-specific data
        mkdir -p ${_FLATPAK_XDG_CACHE_HOME}

        # gpg --import --homedir "${HOME}/flatpak/${FLATPAK_GPG_HOMEDIR}" "${HOME}/flatpak/${FLATPAK_GPG_KEYRING}"
        # flatpak-builder --user --jobs="2" \
        #                      --ccache \
        #                      --force-clean \
        #                      --delete-build-dirs \
        #                      --repo="${HOME}/flatpak/${FLATPAK_LOCAL_REPO}" \
        #                      --state-dir="${HOME}/flatpak/${FLATPAK_STATE_DIR}" \
        #                      "${FLATPAK_NAME}" "${FLATPAK_DNS_PREFIX}.${FLATPAK_NAME}.json" || exit_unset 1
        flatpak-builder --user --jobs="2" \
                             --ccache \
                             --force-clean \
                             --delete-build-dirs \
                             --repo="${FLATPAK_PATH_TO_REPO}" \
                             --state-dir="${FLATPAK_PATH_TO_STATE_DIR}" \
                             "${FLATPAK_NAME}" "${FLATPAK_DNS_PREFIX}.${FLATPAK_NAME}.json" || exit_unset 1

        # -----------------------------------------------------------------------------------------
        # flatpak-build-update-repo — Create a repository from a build directory
        # Synopsis
        # flatpak build-update-repo [OPTION...] LOCATION
        # Description
        # Updates repository metadata for the repository at LOCATION . This command generates an OSTree summary file that lists the contents of the repository. The summary is used by flatpak repo-contents and other commands to display the contents of remote repositories.
        # After this command, LOCATION can be used as the repository location for flatpak add-repo, either by exporting it over http, or directly with a file: url.
        # -----------------------------------------------------------------------------------------
        # flatpak build-update-repo [OPTION...] LOCATION
        # --prune: Remove unreferenced objects in repo.
        # --prune-depth: Only keep at most this number of old versions for any particular ref. Default is -1 which means infinite.
        # --generate-static-deltas: Generate static deltas for all references. This generates from-empty and delta static files that allow for faster download.
        flatpak build-update-repo \
                          --prune \
                          --prune-depth 5 \
                          --generate-static-deltas \
                          --ostree-verbose \
                          ${FLATPAK_PATH_TO_REPO} || exit_unset 1
    else
        exit_unset 1
    fi
}

# Execute build flatpaks
for d in flatpak/*/
do
     build_flatpak ${d}
done
exit_unset 0
