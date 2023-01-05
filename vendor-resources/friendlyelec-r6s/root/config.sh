#!/bin/sh

set -e

add_ubuntu() {
    useradd -G sudo -d /home/ubuntu -m -s /bin/bash ubuntu
    echo "ubuntu:ubuntu" | chpasswd
    echo "root:root" | chpasswd
}

add_lang_pack() {
    apt-get install -y language-pack-en-base
    apt-get install -y dialog apt-utils
}

install_software() {
    apt-get install -y dnsutils file htop ifupdown iputils-ping lshw lsof nano net-tools network-manager openssh-server rfkill tree u-boot-tools wget wireless-tools wpasupplicant
}

set_sshd_config() {
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config.orig
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
    sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
}

main() {
    export DEBIAN_FRONTEND="noninteractive"

    # apt-get update
 
    # add_lang_pack
    # install_software
    # set_sshd_config
    # rm -rf /var/lib/apt/*

    add_ubuntu
    # systemctl enable getty@ttyS2.service
    
    unset DEBIAN_FRONTEND
}

main "$@"
