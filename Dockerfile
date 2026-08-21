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
        python-setuptools \
        python-pyelftools \
        vulkan-icd-loader \
        vulkan-tools mesa-utils \
        vulkan-radeon \
        blender \
        godot \
        scons \
        cppcheck \
        clang \
        mingw-w64 && \
    pacman -Scc --noconfirm && \
    rm -rf /var/cache/pacman/pkg/*

RUN npm install -g @agegr/pi-web@latest

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
        playwright-cli && \
    yay -Scc --noconfirm && \
    rm -rf /home/builder/.cache/yay

USER root
