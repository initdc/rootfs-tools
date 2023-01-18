# frozen_string_literal: true

# https://wiki.gentoo.org/wiki//etc/fstab
# https://wiki.archlinux.org/title/fstab
# https://wiki.archlinux.org/title/persistent_block_device_naming

def label_to(par, label)
    output = `mount | grep #{par}`.chomp
    type = output.split(" ")[4]
    case type
    when "swap"
        `swaplabel -L '#{label}' #{par}`
    when "ext2", "ext3", "ext4"
        `e2label #{par} '#{label}'`
    when "fat", "vfat"
        `fatlabel #{par} '#{label}'`
    when "btrfs"
        `btrfs filesystem label #{par} '#{label}'`
    when "exfat"
        `exfatlabel #{par} '#{label}'`
    when "ntfs"
        `ntfslabel #{par} '#{label}'`
    else
        puts "Not supported FS type"
    end
end

if __FILE__ == $0
    label_to("/dev/sdc8", "cloudimg-rootfs")
end
