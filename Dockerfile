FROM ubuntu:noble-20260217

RUN userdel -r ubuntu
RUN dpkg --add-architecture i386 \
    && apt-get update \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
        dwm \
        fonts-noto-cjk \
        gosu \
        locales-all \
        stterm \
        suckless-tools \
        sudo \
        vim \
        xorgxrdp \
        xrdp \
        wine \
        wine32 \
    && rm -rf /var/lib/apt/lists/*

COPY x-terminal-emulator.sh /usr/local/bin/x-terminal-emulator
COPY entrypoint.sh /entrypoint
ENTRYPOINT ["/entrypoint"]
