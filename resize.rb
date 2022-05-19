def resizeImage img, size
    `e2fsck -f #{img}`
    `resize2fs #{img} #{size}`
end