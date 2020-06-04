#!/bin/bash

source vnc_env.sh

cp -rf vnc_resources /tmp/


# apt-get update
apt-get install -y \
        inetutils-ping \
        lsb-release \
        net-tools \
        unzip \
        vim \
        zip \
        curl \
        git \
        wget \
    && rm -rf /var/lib/apt/lists/*


cd /tmp/vnc_resources ; \
chown root jq-linux64 ; \
chmod +x jq-linux64 ; \
mv -f jq-linux64 /usr/bin/jq ; \
cd - ; \



# apt-get update
apt-get install -y \
        mousepad \
        locales \
        supervisor \
        xfce4 \
        xfce4-terminal \
    && locale-gen en_US.UTF-8 \
    && apt-get purge -y \
        pm-utils \
        xscreensaver* \
    && rm -rf /var/lib/apt/lists/*


cat /tmp/vnc_resources/tigervnc-1.10.1.x86_64.tar.gz | tar xz --strip 1 -C /

echo "->>>>> NO_VNC_HOME = ${NO_VNC_HOME}"

# apt-get update
apt-get install -y \
        python-numpy gettext \
    && mkdir -p ${NO_VNC_HOME}/utils/websockify \
    && cat /tmp/vnc_resources/noVNC-1.1.0.tar.gz | tar xz --strip 1 -C ${NO_VNC_HOME} \
    && cat /tmp/vnc_resources/websockify-0.9.0.tar.gz | tar xz --strip 1 -C ${NO_VNC_HOME}/utils/websockify \
    && chmod +x -v ${NO_VNC_HOME}/utils/*.sh \
    && rm -rf /var/lib/apt/lists/*    


echo \
"<!DOCTYPE html>" \
"<html>" \
"    <head>" \
"        <title>noVNC</title>" \
"        <meta charset=\"utf-8\"/>" \
"    </head>" \
"    <body>" \
"        <p><a href=\"vnc_lite.html\">noVNC Lite Client</a></p>" \
"        <p><a href=\"vnc.html\">noVNC Full Client</a></p>" \
"    </body>" \
"</html>" \
> ${NO_VNC_HOME}/index.html

CALL_USER=${SUDO_USER:-${USER}}

cd $HOME
echo $HOME
mkdir -p ./.config/xfce4/xfconf/
cp -rf /tmp/vnc_resources/home/Desktop ./
chown -R $CALL_USER ./Desktop
cp -rf /tmp/vnc_resources/home/config/xfce4/panel ./.config/xfce4/
cp -rf /tmp/vnc_resources/home/config/xfce4/xfconf/xfce-perchannel-xml ./.config/xfce4/xfconf/
chown -R $CALL_USER ./.config/xfce4
cd -




gtk-update-icon-cache -f /usr/share/icons/hicolor


rm -rf /tmp/vnc_resources

echo "VNC Install Finished!"
