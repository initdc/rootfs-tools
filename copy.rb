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
def copy_kernel(src, dest, extra = [])
    file_paths = %w[
        /boot/
        /lib/firmware/
        /lib/modprobe.d/
        /lib/modules/
        /usr/lib/linux/

        /etc/fstab
    ]
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
            cmd = "dd if=#{src}p#{par} of=#{dest}p#{par}"
            puts cmd
            system cmd
        end
    else
        copy_map.each do |par_s, par_d|
            cmd = "dd if=#{src}p#{par_s} of=#{dest}p#{par_d}"
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

    # copy_kernel "/home/ubuntu/vscode/rootfs-tools/vf-de", "origin", v_extra
    copy_kernel "/home/ubuntu/vscode/rootfs-tools/origin", "/media/ubuntu/94ee1ed4-92f9-43dd-9ba9-c8be451fa14a", v_extra

    # copy_par "/dev/loop5", "/dev/loop6"
end