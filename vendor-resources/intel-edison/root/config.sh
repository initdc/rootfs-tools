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
    apt-get install -y curl dnsutils htop ifupdown iputils-ping kmod nano net-tools openssh-server rfkill sudo tree vim wget wireless-tools wpasupplicant
}

main() {
    export DEBIAN_FRONTEND="noninteractive"

    apt-get update

    add_lang_pack
    install_software
    add_ubuntu

    unset DEBIAN_FRONTEND
}

main "$@"
