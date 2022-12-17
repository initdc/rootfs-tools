# frozen_string_literal: true

def mountImage(img, path)
    puts "mounting image #{img} on #{path}"
    `mount -o loop #{img} #{path}`
end

def unmountImage(path)
    puts "unmounting image on #{path}"
    `umount #{path}`
end

# ref: https://wiki.alpinelinux.org/wiki/How_to_make_a_cross_architecture_chroot
def mountDev(path)
    puts "mounting /dev on  #{path}"
    `mount -t proc /proc #{path}/proc`
    `mount -t sysfs /sys #{path}/sys`
    `mount -o bind /dev #{path}/dev`
    `mount -o bind /dev/pts #{path}/dev/pts`
    `mount -o bind /run #{path}/run`
end

def unmountDev(path)
    puts "unmounting /dev on #{path}"
    `umount #{path}/proc`
    `umount #{path}/sys`
    `umount #{path}/dev/pts`
    `umount #{path}/dev`
    `umount #{path}/run`
end

# https://askubuntu.com/questions/69363/mount-single-partition-from-image-of-entire-disk-device
def getImageLoops(img)
    cmd = "losetup | grep #{img}"
    IO.popen(cmd) do |r|
        lines = r.readlines
        return nil if lines.empty?

        loops = []
        lines.each do |line|
            lo = line.delete_suffix("\n").split(" ").first
            loops.push lo
        end
        return loops
    end
end

def mountLoop(img, *opt)
    loop_dev = opt[0]
    offset = opt[1]

    unless loop_dev.nil?
        if !offset.nil?
            `losetup -o #{offset} #{loop_dev} #{img}`
        else
            `losetup #{loop_dev} #{img}`
        end
        return loop_dev
    end

    output = `losetup -Pf --show #{img}`
    return output.delete_suffix("\n")
end

def mountCombinedImage(img, path, *opt)
    par = opt[0]
    loop_dev = opt[1]

    system "fdisk -l #{img}"

    if par.nil?
        print "which partition to mount: "
        par = gets.delete_suffix("\n")
        # p par
    end

    if loop_dev.nil?
        loop_dev = mountLoop img
    else
        mountLoop img, loop_dev
    end

    loop_par = "#{loop_dev}p#{par}"

    puts "mounting #{loop_par} on #{path}"
    `mount #{loop_par} #{path}`
end

def unmountCombinedImage(img)
    loops = getImageLoops img
    loops.each do |lo|
        puts "unmounting combined image on #{lo}"
        `losetup -d #{lo}`
    end
end

# img = "ubuntu-core-gnome.img"
# path = "mars-A1-ub18-core"

img = "/home/ubuntu/workspace/ubuntu-22.10-preinstalled-server-riscv64+licheerv.img"
path = "rootfs"

# mountImage img, path
# mountCombinedImage img, path, 1
# mountDev path

unmountDev path
puts "waiting for 3s"
sleep 3
unmountImage path
unmountCombinedImage img
