#!/bin/bash
set -euo pipefail

USER_NAME=${USER_NAME:-wine}
USER_PASSWD="${USER_PASSWD:-${USER_NAME}}"
USER_UID=${USER_UID:-1000}
USER_GID=${USER_GID:-"${USER_UID}"}
RUN_AS_ROOT=${RUN_AS_ROOT:-""}
TZ=${TZ:-UTC}
LANG=${LANG:-POSIX}
DPI=${DPI:-""}
KEYMAP=${KEYMAP:-""}

ln -snf "/usr/share/zoneinfo/${TZ}" /etc/localtime
update-locale LANG=${LANG}

usermod -u $USER_UID -g $USER_GID $USER_NAME
echo "${USER_NAME}:${USER_NAME}" | chpasswd

if [ -n "${DPI}" ]; then
    sed -i "
    /^\\[Xorg\\]/,/^$/ {
        /^$/i param=-dpi\nparam=${DPI}
    }" /etc/xrdp/sesman.ini
fi

if [ -n "${KEYMAP}" ]; then
    sed -i "
    /^\\[default_rdp_layouts\\]/,/^$/ {
        /${KEYMAP#*:}/s/^rdp_layout_.*=/rdp_layout_${KEYMAP%:*}=/
    }" /etc/xrdp/xrdp_keyboard.ini
fi

rm -f /var/run/xrdp/xrdp*.pid

xrdp-sesman

if [ $# -eq 0 ]; then
    exec xrdp --nodaemon
else
    xrdp

    if [ -n "${RUN_AS_ROOT}" ]; then
        exec "$@"
    else
        exec setpriv --reuid=$USER_UID --regid=$USER_GID --init-groups -- "$@"
    fi
fi
