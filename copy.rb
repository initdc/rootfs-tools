# frozen_string_literal: true

require "./decompress"

class Copy
    @temp_dir = "temp"
    def initialize(src, dest)
        @src = src
        @dest = dest

        @pwd = Dir.pwd
        `mkdir -p #{@pwd}/#{@temp_dir}`
    end

    class << self
        # ls -d1 */
        def Fedora(src, dest)
            @pwd = Dir.pwd

            `mkdir -p #{@temp_dir}/Fedora`
            Decompress.untar "#{@temp_dir}/Fedora", src
            Dir.chdir "#{@temp_dir}/Fedora" do
                inner = `ls -d1 */`.delete "\/\n"
                puts "#{inner}/layer.tar"
                if File.exist? "#{inner}/layer.tar"
                    Decompress.done "#{inner}/layer.tar" if Decompress.untar "#{@pwd}/#{dest}", "#{inner}/layer.tar"
                else
                    puts "layer.tar not exist"
                end
            end
        end

        def Arch(src, dest)
            @pwd = Dir.pwd

            `mkdir -p #{@temp_dir}/Arch`
            Decompress.ungz "#{@temp_dir}/Arch", src
            Dir.chdir "#{@temp_dir}/Arch" do
                inner = `ls -d1 */`.delete "\/\n"
                return system("sudo cp -a #{inner}/* #{@pwd}/#{dest}")
            end
        end
    end
end

# https://launchpad.net/~canonical-kernel-team/+archive/ubuntu/ppa/+build/24173564
def copy_kernel(src, dest, extra = [], no_default = false)
    file_paths = %w[
        /boot/
        /lib/firmware/
        /lib/modprobe.d/
        /lib/modules/
        /usr/lib/linux/

        /etc/fstab
    ]
    file_paths = [] if no_default
    file_paths += extra

    # exec_dir = Dir.pwd

    `mkdir -p #{dest}`
    Dir.chdir dest do
        file_paths.each do |file_path|
            cp_src = "#{src}#{file_path}"
            dest_path = file_path.delete_prefix("/")

            # is_file = if dest_path.end_with?('/')
            #               false
            #           else
            #               true
            #           end

            parent_arr = dest_path.split("/")
            parent_arr.pop
            # p parent_arr

            parent_dir = case parent_arr.size
                         when 0
                             ""
                         when 1
                             parent_arr[0]
                         else
                             parent_arr.join("/")
                         end

            if parent_dir != ""
                `mkdir -p #{parent_dir}`
                Dir.chdir parent_dir do
                    puts Dir.pwd

                    cmd = "cp -a #{cp_src} ."
                    puts cmd
                    system cmd
                    puts
                end
            else
                puts Dir.pwd

                cmd = "cp -a #{cp_src} ."
                puts cmd
                system cmd
                puts
            end
        end
    end
end

# copy_map = {
#     "0": "1",
#     "2": "2"
# }
def copy_par(src, dest, copy_map = nil)
    if copy_map.nil?
        print `ls -d1 #{src}p*`
        puts

        puts "which partition(s) you want copy:"
        puts "(eg: 1, 3,4)"
        pars = gets.delete_suffix("\n").delete(" ").split(",")
        pars.each do |par|
            dd_src = `ls -d1 #{src}*#{par}`.delete_suffix("\n")
            dd_dest = `ls -d1 #{dest}*#{par}`.delete_suffix("\n")
            cmd = "dd if=#{dd_src} of=#{dd_dest}"
            puts cmd
            system cmd
        end
    else
        copy_map.each do |par_s, par_d|
            dd_src = `ls -d1 #{src}*#{par_s}`.delete_suffix("\n")
            dd_dest = `ls -d1 #{dest}*#{par_d}`.delete_suffix("\n")
            cmd = "dd if=#{dd_src} of=#{dd_dest}"
            puts cmd
            system cmd
        end
    end
end

if __FILE__ == $0
    # Copy.Fedora "cache/Fedora-Container-Base-36-1.5.x86_64.tar.xz", "fd-36"
    # Copy.Arch "cache/archlinux-bootstrap-2022.09.03-x86_64.tar.gz", "arch"

    l_extra = %w[
        /usr/lib/linux-allwinner-5.17-tools-5.17.0-1003/
        /usr/lib/libcpupower.so.5.17.0-1003
        /usr/lib/linux-tools/
    ]

    v_extra = %w[
        /usr/lib/linux-image-5.15.0-starfive/
    ]

    extlinux_uEnv = %w[
        /boot/extlinux/
        /boot/uEnv.txt
    ]

    r_extra = %w[
        /lib/firmware/
        /lib/modules/
    ]

    r_map = {
        "2": "8",
    }
    # copy_kernel "/media/ubuntu/rootfs", "origin", r_extra, true
    # copy_kernel "/home/ubuntu/vscode/rootfs-tools/origin", "rootfs"

    copy_par "/dev/loop14", "/dev/loop15", r_map
end