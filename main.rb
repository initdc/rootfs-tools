require "./fetch.rb"
require "./mount.rb"

ROOTFS_DIR = "rootfs"
ROOTFS_IMG = "ubuntu-rootfs.img"

SIZE = "8192"

def main
    fetch_ubuntu
    
    `dd if=/dev/zero of=#{ROOTFS_IMG} bs=1MB count=0 seek=#{SIZE}`
    `mkfs.ext4 -F #{ROOTFS_IMG}`
    `mount -o loop #{ROOTFS_IMG} #{ROOTFS_DIR}`

    `tar -C #{ROOTFS_DIR} -zxvf #{CACHE_DIR}/#{FILE}`
    `cp arm_install.sh #{ROOTFS_DIR}/tmp/`

    mount ROOTFS_DIR
    `chroot #{ROOTFS_DIR} /bin/sh /tmp/arm_install.sh`

    unmount ROOTFS_DIR
    `umount #{ROOTFS_DIR}`
end

main