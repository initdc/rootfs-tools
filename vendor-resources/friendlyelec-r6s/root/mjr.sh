#!/bin/sh

set -e

add_user() {
    useradd -G sudo -d /home/manjaro -m -s /bin/bash manjaro
    echo "manjaro:manjaro" | chpasswd
    echo "root:root" | chpasswd
}

set_sshd_config() {
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config.orig
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
    sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
}

main() {
    add_user    
}

main "$@"
