# ─── Stage 1: Build yay ───────────────────────────────────────────────────────
FROM archlinux:latest AS yay-builder

RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm base-devel git && \
    pacman -Scc --noconfirm && \
    rm -rf /var/cache/pacman/pkg/*

RUN useradd -m builder && \
    echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER builder
WORKDIR /home/builder

RUN git clone https://aur.archlinux.org/yay.git && \
    cd yay && \
    makepkg -si --noconfirm && \
    rm -rf /home/builder/yay


# ─── Stage 2: Main image ──────────────────────────────────────────────────────
FROM archlinux:latest

RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm \
        base-devel \
        go \
        nodejs \
        npm \
        pnpm \
        yarn \
        nano \
        git \
        curl \
        wget \
        procps-ng \
        util-linux \
        sqlc \
        gopls\
        typescript-language-server \
        cpio \
        unzip \
        rsync \
        bc \
        ncurses \
        dtc \
        tzdata \
        sqlite \
        wl-clipboard \
        swig \
        uv \
        python \
        python-pip \
        python-pipx \
        python-setuptools \
        python-pyelftools \
        vulkan-icd-loader \
        vulkan-tools mesa-utils \
        vulkan-radeon \
        blender \
        rust \
        rust-src \
        rust-analyzer \
        godot \
        scons \
        cppcheck \
        clang \
        upx \
        mingw-w64 \
        jdk21-openjdk && \
    pacman -Scc --noconfirm && \
    rm -rf /var/cache/pacman/pkg/*

RUN npm install -g @agegr/pi-web@latest

ENV PIPX_HOME=/opt/pipx
ENV PIPX_BIN_DIR=/usr/local/bin
RUN pipx install "headroom-ai[all]"

COPY --from=yay-builder /usr/bin/yay /usr/bin/yay

RUN useradd -m builder && \
    echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER builder
WORKDIR /home/builder

RUN yay -S --noconfirm --answerdiff None --answerclean None \
        crush-bin \
        codegraph-bin \
        pi-coding-agent-bin \
        rtk-bin \
        android-sdk-cmdline-tools-latest \
        android-sdk-platform-tools \
        android-sdk-build-tools-35 \
        android-sdk-build-tools \
        android-platform-36 \
        android-emulator \
        android-google-apis-x86-64-system-image \
        playwright-cli && \
    yay -Scc --noconfirm && \
    rm -rf /home/builder/.cache/yay

USER root
