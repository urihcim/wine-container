#!/bin/bash
set -euo pipefail

USER_NAME=${USER_NAME:-wineuser}
USER_PASSWD=${USER_PASSWD:-"$(openssl passwd -1 -salt "$(openssl rand -base64 6)" "${USER_NAME}")"}
USER_HOME=${USER_HOME:-/home/"${USER_NAME}"}
USER_UID=${USER_UID:-1000}
USER_GID=${USER_GID:-"${USER_UID}"}
RUN_AS_ROOT=${RUN_AS_ROOT:-""}
TZ=${TZ:-UTC}
DPI=${DPI:-""}
KEYMAP=${KEYMAP:-""}


groupadd -fg "${USER_GID}" "${USER_NAME}"
useradd -u "${USER_UID}" -g "${USER_GID}" -G sudo -p "${USER_PASSWD}" -m -d "${USER_HOME}" -s /bin/bash "${USER_NAME}"

ln -snf "/usr/share/zoneinfo/${TZ}" /etc/localtime
echo "${TZ}" > /etc/timezone

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

rm -f /var/run/xrdp/xrdp-sesman.pid
rm -f /var/run/xrdp/xrdp.pid

xrdp-sesman

if [ $# -eq 0 ]; then
    exec xrdp --nodaemon
else
    xrdp

    if [ -n "${RUN_AS_ROOT}" ]; then
        exec "$@"
    else
        exec gosu "${USER_NAME}" "$@"
    fi
fi
