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

if __FILE__ == $0
    # de_uboot_scr "boot.scr"

    # mk_uboot_scr "boot.script"
    # mk_uboot_scr "boot.script", "abc.scr"
end
