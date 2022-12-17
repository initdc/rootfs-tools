# frozen_string_literal: true

require "./fetch"
require "./decompress"
require "./size"
require "./mount"

CACHE_DIR = "cache"
ROOT_PKG = "ubuntu-22.04-minimal-cloudimg-amd64-root.tar.xz"
TEMP_ROOTFS_DIR = "ub-22"
ROOTFS_DIR = "rootfs"
ROOTFS_IMG = "edison-image-edison.ext4"

def main
    `mkdir -p #{CACHE_DIR} #{TEMP_ROOTFS_DIR} #{ROOTFS_DIR}`
    fetch_ubuntu_base CACHE_DIR
    fetch_ubuntu_minimal CACHE_DIR
    `sha256sum -c #{CACHE_DIR}/SHA256SUMS`

    d = Decompress.new TEMP_ROOTFS_DIR, "#{CACHE_DIR}/#{ROOT_PKG}"
    d.matcher

    `cp -a boot #{TEMP_ROOTFS_DIR}`
    `cp -a firmware #{TEMP_ROOTFS_DIR}/lib`
    `cp -a modules #{TEMP_ROOTFS_DIR}/lib`

    `cp -a vendor-resources/intel-edison/* #{TEMP_ROOTFS_DIR}`

    mountDev TEMP_ROOTFS_DIR
    `sudo chroot #{TEMP_ROOTFS_DIR} /bin/bash -c /root/config.sh`
    unmountDev TEMP_ROOTFS_DIR

    s = Size.new TEMP_ROOTFS_DIR, 100, 100, "/dev/sda1"
    size = s.GetSize
    `dd if=/dev/zero of=#{ROOTFS_IMG} bs=1MB count=0 seek=#{size}`
    `mkfs.ext4 -F #{ROOTFS_IMG}`
    `tune2fs -c0 -i0 #{ROOTFS_IMG}`

    mountImage ROOTFS_IMG, ROOTFS_DIR
    `sudo cp -a #{TEMP_ROOTFS_DIR}/* #{ROOTFS_DIR}`
    unmountImage ROOTFS_DIR
end

main
