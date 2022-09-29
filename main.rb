require "fetch"
require "decompress"
require "mount"

ROOTFS_DIR = "edison-ub20"
ROOTFS_IMG = "edison-image-edison.ext4"

SIZE = "400"

def main
    # fetch_ubuntu
    
    `dd if=/dev/zero of=#{ROOTFS_IMG} bs=1MB count=0 seek=#{SIZE}`
    `mkfs.ext4 -F #{ROOTFS_IMG}`
    `mount -o loop #{ROOTFS_IMG} #{ROOTFS_DIR}`

    `tar -C #{ROOTFS_DIR} -zxvf #{CACHE_DIR}/#{FILE}`
    `cp -ar vendor-resources/intel-edison/* #{ROOTFS_DIR}`
    `cp -ar vendor-resources/intel-edison/lib/* #{ROOTFS_DIR}/lib`

    mount ROOTFS_DIR
    `chroot #{ROOTFS_DIR} /bin/sh /root/config.sh`

    unmount ROOTFS_DIR
end

main