#!/bin/sh

set -e

change_hostname() {
    hostnamectl hostname 'visionfive2'
}

add_wheel() {
    groupadd wheel
    sed -i 's/# \%wheel ALL=(ALL:ALL) NOPASSWD: ALL/\%wheel ALL=(ALL:ALL) NOPASSWD: ALL/g' /etc/sudoers
}

add_suse() {
    useradd suse -m -G wheel -s /bin/bash
    echo "suse:byinitdc" | chpasswd
    echo "root:Byinitdc" | chpasswd
}

install_software() {
    zypper install -y htop lshw nano net-tools tree git-core
}

main() {
    install_software
    change_hostname
    add_wheel
    add_suse
}

main "$@"
