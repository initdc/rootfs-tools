# frozen_string_literal: true

def resizeImage(img, size)
    `e2fsck -f #{img}`
    `resize2fs #{img} #{size}`
    # re-format to update inodes
    `mkfs.ext4 -F #{img}`
end
