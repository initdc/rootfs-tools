#!/bin/sh

set -e

add_ubuntu() {
    useradd -G sudo -d /home/ubuntu -m -s /bin/bash ubuntu
    echo "ubuntu:ubuntu" | chpasswd
}

add_lang_pack() {
    apt-get install -y language-pack-en-base
    apt-get install -y dialog apt-utils
}

install_software() {
    apt-get install -y bash-completion curl dnsutils htop ifupdown iputils-ping kmod nano net-tools network-manager openssh-server rfkill sudo systemd systemd-sysv tree vim wget wireless-tools wpasupplicant 
}

main() {
    export DEBIAN_FRONTEND="noninteractive"

    apt-get update
 
    add_lang_pack
    install_software
    rm -rf /var/lib/apt/*

    # add_ubuntu
    systemctl enable getty@ttyS2.service
    
    unset DEBIAN_FRONTEND
}

main "$@"
