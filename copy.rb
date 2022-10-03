require "./decompress"

class Copy
    @@temp_dir = "temp"
    def initialize src, dest
        @src = src
        @dest = dest

        @pwd = Dir.pwd
        `mkdir -p #{@pwd}/#{@@temp_dir}`
    end

    class << self
        # ls -d1 */
        def Fedora src, dest
            @pwd = Dir.pwd

            `mkdir -p #{@@temp_dir}/Fedora`
            Decompress.untar "#{@@temp_dir}/Fedora", src
            Dir.chdir "#{@@temp_dir}/Fedora" do
                inner = `ls -d1 */`.delete "\/\n"
                puts "#{inner}/layer.tar"
                if File.exist? "#{inner}/layer.tar"
                    Decompress.done "#{inner}/layer.tar" if Decompress.untar "#{@pwd}/#{dest}", "#{inner}/layer.tar"
                else
                    puts "layer.tar not exist"
                end
            end
        end

        def Arch src, dest
            @pwd = Dir.pwd

            `mkdir -p #{@@temp_dir}/Arch`
            Decompress.ungz "#{@@temp_dir}/Arch", src
            Dir.chdir "#{@@temp_dir}/Arch" do
                inner = `ls -d1 */`.delete "\/\n"
                return system("sudo cp -a #{inner}/* #{@pwd}/#{dest}")
            end
        end
    end
end

# Copy.Fedora "cache/Fedora-Container-Base-36-1.5.x86_64.tar.xz", "fd-36"
# Copy.Arch "cache/archlinux-bootstrap-2022.09.03-x86_64.tar.gz", "arch"