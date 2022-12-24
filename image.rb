# frozen_string_literal: true

# https://wiki.ubuntu.com/ARM/EditBootscr
def de_uboot_scr(scr, script = nil)
    if script.nil?
        script = if scr.end_with?(".scr")
                     "#{scr}ipt"
                 else
                     "#{scr}.script"
                 end
    end

    `dd if=#{scr} of=#{script} bs=72 skip=1`
end

# https://manpages.ubuntu.com/manpages/jammy/man1/mkimage.1.html
def mk_uboot_scr(script, scr = nil, arch = "arm", comp = "none")
    if scr.nil?
        scr = if script.end_with?(".script")
                  script.delete_suffix("ipt")
              else
                  "#{script}.scr"
              end
    end

    # mkimage [-x] -A arch -O os -T type -C comp -a addr -e ep -n name -d data_file[:data_file...] image
    # mkimage -T list
    `mkimage -A #{arch} -T script -C #{comp} -d #{script} #{scr}`
end

# https://manpages.ubuntu.com/manpages/jammy/en/man1/dd.1posix.html
# https://manpages.ubuntu.com/manpages/jammy/man8/mkfs.8.html
# https://manpages.ubuntu.com/manpages/jammy/man8/mkfs.ext4.8.html
# https://manpages.ubuntu.com/manpages/jammy/en/man8/sfdisk.8.html
def mk_rootfs(img, block_count, block_size = nil, layout = nil, mkfs_cmd = nil)
    dd_bs = if block_size.nil? or block_size.empty?
                ""
            else
                # cmd_opt in func
                # should end with  ' '
                # so we get log with good formatting
                "bs=#{block_size} "
            end

    dd_cmd = "dd if=/dev/zero of=#{img} count=0 seek=#{block_count} #{dd_bs}"
    puts dd_cmd
    system dd_cmd

    if layout.nil? or layout.empty?
        if mkfs_cmd != nil
            cmd = "#{mkfs_cmd} #{img}"
            puts cmd
            system cmd
        end
    else
        cmd = "sfdisk #{img} < #{layout}"
        puts cmd
        system cmd
    end
end

if __FILE__ == $0
    # de_uboot_scr "boot.scr"

    # mk_uboot_scr "boot.script"
    # mk_uboot_scr "boot.script", "abc.scr"

    # mk_rootfs "test-MB.img", 2100, "1MB"
    # mk_rootfs "test-MiB.img", 2001, "1MiB"
    # mk_rootfs "test-MB.img", 2100, "1MB", "vf2"
    mk_rootfs "test-MiB.img", 2001, "1MiB", "vf2"
    # mk_rootfs "test.img", 4096100, "" ,"vf2"
    # mk_rootfs "test.img", 4096100, nil, "vf2"
    # mk_rootfs "test.img", 4096100, nil, nil, "mkfs.ext4 -F"
end
