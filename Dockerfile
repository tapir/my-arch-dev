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
        nano \
        git \
        curl \
        wget \
        sqlc \
        unzip \
        rsync \
        sqlite \
        wl-clipboard \
        vulkan-icd-loader \
        vulkan-tools mesa-utils \
        vulkan-radeon \
        godot \
        scons \
        cppcheck \
        clang \
        upx \
        mingw-w64 \
        ffmpeg \
        github-cli \
        jq \
        wine \
        ghidra \
        valgrind \
        libxtst \
        ttf-dejavu && \
    pacman -Scc --noconfirm && \
    rm -rf /var/cache/pacman/pkg/*

#RUN npm install -g rea-agents

COPY --from=yay-builder /usr/bin/yay /usr/bin/yay

RUN useradd -m builder && \
    echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER builder
WORKDIR /home/builder

RUN yay -S --noconfirm --answerdiff None --answerclean None \
        ttf-ms-fonts \
        codegraph-bin \
        pi-coding-agent-bin \
        rtk-bin && \
    yay -Scc --noconfirm && \
    rm -rf /home/builder/.cache/yay

USER root
