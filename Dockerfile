ARG HANGOVER_VERSION=11.16

FROM debian:trixie-20261104-slim AS base

RUN DEBIAN_FRONTEND="noninteractive" \
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
    && rm -rf /var/lib/apt/lists/*

# amd64: Wine from Debian, with wine32 for 32-bit applications.
FROM base AS wine-amd64

RUN DEBIAN_FRONTEND="noninteractive" \
    && dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        wine \
        wine32 \
    && rm -rf /var/lib/apt/lists/*

# arm64: Hangover, a native arm64 Wine that emulates only the x86 code of
# the application.
FROM base AS wine-arm64

ARG HANGOVER_VERSION
ADD --checksum=sha256:b5493f5903ab3c05f78bf4c03b06ac0005eb26f732437748c1592fefa45e861a \
    https://github.com/AndreRH/hangover/releases/download/hangover-${HANGOVER_VERSION}/hangover_${HANGOVER_VERSION}_debian13_trixie_arm64.tar \
    /tmp/hangover.tar

RUN DEBIAN_FRONTEND="noninteractive" \
    && mkdir /tmp/hangover \
    && tar -xf /tmp/hangover.tar -C /tmp/hangover \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        /tmp/hangover/hangover-libarm64ecfex_*.deb \
        /tmp/hangover/hangover-libwow64fex_*.deb \
        /tmp/hangover/hangover-wine_*.deb \
        /tmp/hangover/hangover-wowbox64_*.deb \
    && rm -rf /tmp/hangover /tmp/hangover.tar /var/lib/apt/lists/*

# Emulator for i386 applications. FEX reproduces x86 exceptions more
# faithfully than Box64, which copy-protected applications depend on. Set
# HODLL=wowbox64.dll to use Box64 instead.
ENV HODLL=libwow64fex.dll

FROM wine-${TARGETARCH}

RUN useradd -G sudo -s /bin/bash -m -d /home/wine wine \
    && echo "%sudo ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/wine

EXPOSE 3889

COPY x-terminal-emulator.sh /usr/local/bin/x-terminal-emulator
COPY entrypoint.sh /entrypoint
ENTRYPOINT ["/entrypoint"]
