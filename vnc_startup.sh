#!/bin/bash

source vnc_env.sh

VNC_IP=$(hostname -i)

mkdir -p "${HOME}"/.vnc
PASSWD_PATH="${HOME}/.vnc/passwd"

echo "${VNC_PW}" | vncpasswd -f >> "${PASSWD_PATH}"
chmod 600 "${PASSWD_PATH}"

echo "Starting noVNC"
"${NO_VNC_HOME}"/utils/launch.sh --vnc localhost:${VNC_PORT} --listen ${NO_VNC_PORT} &> "${VNC_STARTUPDIR}"/no_vnc_startup.log &
PID_SUB=$!

echo "Starting VNC server ..."
echo "... remove old VNC locks to be a reattachable service"
vncserver -kill ${DISPLAY} &> "${VNC_STARTUPDIR}"/vnc_startup.log \
    || rm -rfv /tmp/.X*-lock /tmp/.X11-unix &> "${VNC_STARTUPDIR}"/vnc_startup.log \
    || echo "... no locks present"

echo "... VNC params: VNC_COL_DEPTH=${VNC_COL_DEPTH}, VNC_RESOLUTION=${VNC_RESOLUTION}"
echo "... VNC params: VNC_BLACKLIST_TIMEOUT=${VNC_BLACKLIST_TIMEOUT}, VNC_BLACKLIST_THRESHOLD=${VNC_BLACKLIST_THRESHOLD}"
vncserver ${DISPLAY} -depth ${VNC_COL_DEPTH} -geometry ${VNC_RESOLUTION} \
    -BlacklistTimeout ${VNC_BLACKLIST_TIMEOUT} \
    -BlacklistThreshold ${VNC_BLACKLIST_THRESHOLD} &> "${VNC_STARTUPDIR}"/no_vnc_startup.log

### log connect options
echo "... VNC server started on display ${DISPLAY}"
echo "Connect via VNC viewer with ${VNC_IP}:${VNC_PORT}"
echo "Connect via noVNC with http://${VNC_IP}:${NO_VNC_PORT}"


