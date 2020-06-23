#!/bin/bash

echo "->>>>>>>>>> VNC Stop <<<<<<<<<<"

source vnc_env.sh


echo "Stopping VNC server ..."

vncserver -kill ${DISPLAY} &> "${VNC_STARTUPDIR}"/vnc_startup.log \
    || rm -rfv /tmp/.X*-lock /tmp/.X11-unix/* &> "${VNC_STARTUPDIR}"/vnc_stop.log


rm -f "${HOME}"/.ICEauthority
rm -f "${HOME}"/.Xauthority
rm -f "${HOME}"/.vnc/passwd

echo "VNC server stopped !"
