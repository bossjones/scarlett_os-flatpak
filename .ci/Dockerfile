FROM fedora:27

LABEL Maintainer "Malcolm Jones <bossjones@theblacktonystark.com>"

ENV NON_ROOT_USER developer
ENV container docker
ENV TERM xterm-256color

RUN echo "fastestmirror=True" >> /etc/dnf/dnf.conf
RUN [ -e /etc/yum.conf ] && sed -i '/tsflags=nodocs/d' /etc/yum.conf || true

ARG HOST_USER_ID=1000
ENV HOST_USER_ID ${HOST_USER_ID}
ARG HOST_GROUP_ID=1000
ENV HOST_GROUP_ID ${HOST_GROUP_ID}

RUN set -xv ; \
    dnf -y update && \
    ln -fs /usr/share/zoneinfo/UTC /etc/localtime && \
    dnf -y reinstall "*"; \
    dnf -y remove vim-minimal && \
    dnf -y install \
    adwaita-icon-theme \
    atk-devel \
    at-spi2-atk-devel \
    avahi-gobject-devel \
    cairo-devel \
    cairo-gobject-devel \
    ccache \
    colord-devel \
    cups-devel \
    desktop-file-utils \
    elfutils-libelf-devel \
    fribidi-devel \
    gcc \
    gcc-c++ \
    gdk-pixbuf2-devel \
    gdk-pixbuf2-modules \
    gettext \
    git \
    glib2-devel \
    glibc-devel \
    glibc-headers \
    gobject-introspection-devel \
    graphene-devel \
    gstreamer1-devel \
    gstreamer1-plugins-good \
    gstreamer1-plugins-bad-free-devel \
    gstreamer1-plugins-base-devel \
    gtk-doc \
    iso-codes \
    itstool \
    json-glib-devel \
    libattr-devel \
    libepoxy-devel \
    libffi-devel \
    libmount-devel \
    librsvg2 \
    libselinux-devel \
    libXcomposite-devel \
    libXcursor-devel \
    libXcursor-devel \
    libXdamage-devel \
    libXfixes-devel \
    libXi-devel \
    libXinerama-devel \
    libxkbcommon-devel \
    libXrandr-devel \
    libXrender-devel \
    libxslt \
    mesa-dri-drivers \
    mesa-libEGL-devel \
    mesa-libwayland-egl-devel \
    ninja-build \
    pango-devel \
    pcre-devel \
    python3 \
    python3-pip \
    python3-wheel \
    redhat-rpm-config \
    sassc \
    systemtap-sdt-devel \
    vulkan-devel \
    wayland-devel \
    wayland-protocols-devel \
    which \
    xorg-x11-server-Xvfb \
  && \
    dnf install flatpak flatpak-builder wget git bzip2 elfutils make ostree -y \
  && \
        dnf -y install \
        abrt \
        bash-completion \
        bc \
        blktrace \
        btrfs-progs \
        crash \
        dnf-plugins-core && \
    dnf install -y gcc zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel tk-devel && \
    dnf install -y zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel xz xz-devel && \
    dnf install -y @development-tools && \
    dnf reinstall -y glibc-devel.x86_64 && \
    dnf install python3-devel python3-pyOpenSSL.noarch python2-pyOpenSSL.noarch -y; \
    dnf group install "C Development Tools and Libraries" -y; \
    dnf install -y \
        wget \
        curl \
        vim \
        glibc-langpack-en.x86_64 \
        redhat-rpm-config \
        htop \
        perf \
        net-tools \
        file \
        atop \
        ltrace \
        bridge-utils \
        ca-certificates \
        iftop \
        iperf \
        iproute \
        bash \
        bash-completion \
        gettext \
        ncurses; \
    dnf install -y git \
        gcc-c++ \
        gjs \
        gjs-devel \
        libpeas-devel \
        gtksourceview3-devel \
        libgit2-devel \
        libgit2-glib-devel \
        clang-devel \
        file \
        vala-devel \
        vala \
        llvm-devel \
        vte-devel \
        vte291-devel \
        vala-tools \
        redhat-rpm-config; \
    dnf groupinstall -y development-libs \
                        development-tools \
                        gnome-software-development; \
    dnf -y install ninja-build \
        appstream-devel \
        autoconf \
        automake \
        boost-devel \
        ctags \
        ctags-etags \
        dbus-devel \
        dbus-x11 \
        desktop-file-utils \
        devhelp-devel \
        devhelp-libs \
        enchant-devel \
        file \
        findutils \
        flatpak-builder \
        flatpak-devel \
        flatpak-libs \
        elfutils \
        flex \
        bison \
        fpaste \
        gcc \
        gcc-c++ \
        gcc-gfortran \
        gcc-objc \
        gcc-objc++ \
        gdb \
        gdb-gdbserver \
        gettext \
        git-core \
        gmock-devel \
        gnustep-base-devel \
        gspell-devel \
        gtest-devel \
        java-devel \
        json-glib-devel \
        jsonrpc-glib-devel \
        libappstream-glib \
        libappstream-glib-builder-devel \
        libappstream-glib-devel \
        libdazzle-devel \
        libgcc \
        libgit2-glib-devel \
        libpeas-devel \
        libsoup-devel \
        libsysprof-ui \
        libxml2-devel \
        mono-core \
        mono-devel \
        procps-ng \
        psmisc \
        qt5-qtbase-devel \
        sudo \
        sysprof-devel \
        template-glib-devel \
        vala \
        vim \
        tmux \
        vte291-devel \
        webkit2gtk3-devel \
        wxGTK3-devel \
        "pkgconfig(protobuf)" \
        "pkgconfig(glib-2.0)" \
        "pkgconfig(gobject-introspection-1.0)" \
        "pkgconfig(zlib)"; \
        dnf install -y \
        yum-utils \
        rpm-build \
        pixman-devel \
        libpng-devel \
        libxml2-devel \
        freetype-devel \
        fontconfig-devel \
        gtk-doc \
        gnome-common \
        intltool \
        libjpeg-devel \
        libtiff-devel \
        hicolor-icon-theme \
        abattis-cantarell-fonts \
        liberation-mono-fonts \
        liberation-sans-fonts \
        liberation-serif-fonts \
        python-mako \
        ncurses-devel \
        icon-naming-utils \
        dbus-devel \
        desktop-file-utils \
        libuuid-devel \
        appdata-tools \
        iso-codes-devel \
        mozjs24-devel \
        readline-devel \
        dbus-glib-devel \
        gcc-c++ \
        createrepo \
        lighttpd \
        gnome-doc-utils \
        vala-devel \
        vala-tools \
        libxslt-devel \
        fuse-devel \
        libarchive-devel \
        libcroco-devel \
        libpeas-loader-python3.x86_64 \
        python3-lxml \
        python3-jedi.noarch \
        python2-jedi \
        vim-jedi; \
        dnf remove openssl-devel -y && \
    dnf install compat-openssl10-devel -y && \
        dnf clean all

RUN pip3 install --upgrade pip \
        && \
    pip3 install \
                --no-cache-dir \
                --upgrade \
                --ignore-installed \
                --force-reinstall \
                setuptools wheel \
            && \
    pip3 install meson

RUN set -xe \
    && useradd -U -d /home/${NON_ROOT_USER} -m -r -G adm,tty,audio ${NON_ROOT_USER} \
    && usermod -a -G ${NON_ROOT_USER} -s /bin/bash -u ${HOST_USER_ID} ${NON_ROOT_USER} \
    && groupmod -g ${HOST_GROUP_ID} ${NON_ROOT_USER} \
    && ( mkdir /home/${NON_ROOT_USER}/.ssh \
    && chmod og-rwx /home/${NON_ROOT_USER}/.ssh \
    && echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key" > /home/${NON_ROOT_USER}/.ssh/authorized_keys \
    ) \
    && echo "${NON_ROOT_USER}     ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
    && echo "%${NON_ROOT_USER}     ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
    && cat /etc/sudoers \
    && echo "${NON_ROOT_USER}:${NON_ROOT_USER}" | chpasswd && \
    mkdir /var/run/dbus && \
    chown ${NON_ROOT_USER}:${NON_ROOT_USER} -Rv /home/${NON_ROOT_USER}

USER ${NON_ROOT_USER}
WORKDIR /home/${NON_ROOT_USER}

ENV LANG C.UTF-8

