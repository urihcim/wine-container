FROM debian:trixie-20260406-slim

RUN DEBIAN_FRONTEND="noninteractive" \
    && dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        dwm \
        gosu \
        locales \
        stterm \
        suckless-tools \
        sudo \
        vim-tiny \
        xorgxrdp \
        xrdp \
        wine \
        wine32 \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -G sudo -s /bin/bash -m -d /home/wine wine \
    && echo "%sudo ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/wine

EXPOSE 3889

COPY x-terminal-emulator.sh /usr/local/bin/x-terminal-emulator
COPY entrypoint.sh /entrypoint
ENTRYPOINT ["/entrypoint"]
