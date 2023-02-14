#!/bin/sh

set -e

main() {
    # apt-get update
    # apt-get upgrade -y

    chmod o+x /usr/lib/dbus-1.0/dbus-daemon-launch-helper
    chmod +x /etc/rc.local

    export APT_INSTALL="apt-get install -fy --allow-downgrades"

    #---------------power management --------------
    ${APT_INSTALL} pm-utils triggerhappy
    cp /etc/Powermanager/triggerhappy.service  /lib/systemd/system/triggerhappy.service

    #---------------Rga--------------
    ${APT_INSTALL} /packages/rga/*.deb

    echo -e "\033[36m Setup Video.................... \033[0m"
    ${APT_INSTALL} gstreamer1.0-plugins-bad gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-alsa \
    gstreamer1.0-plugins-base-apps qtmultimedia5-examples

    ${APT_INSTALL} /packages/mpp/*
    ${APT_INSTALL} /packages/gst-rkmpp/*.deb
    ${APT_INSTALL} /packages/gstreamer/*.deb
    ${APT_INSTALL} /packages/gst-plugins-base1.0/*.deb
    ${APT_INSTALL} /packages/gst-plugins-bad1.0/*.deb
    ${APT_INSTALL} /packages/gst-plugins-good1.0/*.deb

    #---------Camera---------
    echo -e "\033[36m Install camera.................... \033[0m"
    ${APT_INSTALL} cheese v4l-utils
    ${APT_INSTALL} /packages/rkisp/*.deb
    ${APT_INSTALL} /packages/rkaiq/*.deb
    ${APT_INSTALL} /packages/libv4l/*.deb

    #---------Xserver---------
    echo -e "\033[36m Install Xserver.................... \033[0m"
    ${APT_INSTALL} /packages/xserver/*.deb

    #---------------Openbox--------------
    echo -e "\033[36m Install openbox.................... \033[0m"
    ${APT_INSTALL} /packages/openbox/*.deb

    #---------update chromium-----
    ${APT_INSTALL} /packages/chromium/*.deb

    #------------------libdrm------------
    echo -e "\033[36m Install libdrm.................... \033[0m"
    ${APT_INSTALL} /packages/libdrm/*.deb

    #------------------libdrm-cursor------------
    echo -e "\033[36m Install libdrm-cursor.................... \033[0m"
    ${APT_INSTALL} /packages/libdrm-cursor/*.deb

    # Only preload libdrm-cursor for X
    sed -i "/libdrm-cursor.so/d" /etc/ld.so.preload
    sed -i "1aexport LD_PRELOAD=libdrm-cursor.so.1" /usr/bin/X

    #------------------pcmanfm------------
    echo -e "\033[36m Install pcmanfm.................... \033[0m"
    ${APT_INSTALL} /packages/pcmanfm/*.deb

    #------------------rkwifibt------------
    echo -e "\033[36m Install rkwifibt.................... \033[0m"
    ${APT_INSTALL} /packages/rkwifibt/*.deb
    ln -s /system/etc/firmware /vendor/etc/

    if [ "$VERSION" == "debug" ]; then
    #------------------glmark2------------
    echo -e "\033[36m Install glmark2.................... \033[0m"
    ${APT_INSTALL} /packages/glmark2/*.deb
    fi

    echo -e "\033[36m Install synaptic/onboard.................... \033[0m"
    ${APT_INSTALL} synaptic onboard

    echo -e "\033[36m Install network vpn.................... \033[0m"
    ${APT_INSTALL} network-manager-l2tp network-manager-openvpn network-manager-pptp network-manager-strongswan network-manager-vpnc
    apt install -fy network-manager-gnome --reinstall

    #------------------pulseaudio---------
    echo -e "\033[36m Install pulseaudio................. \033[0m"
    no|apt-get install -fy --allow-downgrades /packages/pulseaudio/*.deb

    # mark package to hold
    apt list --installed | grep -v oldstable | cut -d/ -f1 | xargs apt-mark hold

    #---------------Custom Script--------------
    systemctl mask systemd-networkd-wait-online.service
    systemctl mask NetworkManager-wait-online.service
    rm /lib/systemd/system/wpa_supplicant@.service

    #---------------Clean--------------
    # rm -rf /var/cache/apt/archives/*.deb
    # rm -rf /var/lib/apt/lists/*
}

main "$@"
