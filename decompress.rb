# frozen_string_literal: true

class Decompress
    def initialize(dir, file)
        @dir = dir
        @file = file
    end

    class << self
        def unzip(dir, file)
            return system("unzip -d #{dir} #{file}")
        end

        def untar(dir, file)
            return system("tar -C #{dir} -xvf #{file}")
        end

        def ungz(dir, file)
            return system("tar -C #{dir} -zxvf #{file}")
        end

        def un7z(dir, file)
            return system("7z x -o#{dir} #{file}")
        end

        # https://www.cnblogs.com/Andy-Lv/p/5304247.html
        def uncpio(dir, file)
            pwd_file = "#{Dir.pwd}/#{file}"
            # puts pwd_file
            Dir.chdir dir do
                return system("cpio -i < #{pwd_file}")
            end
        end

        def done(file)
            puts "decompress #{file} done"
        end
    end

    def matcher
        ext = File.extname(@file)
        # puts ext
        case ext
        when ".zip"
            Decompress.done @file if Decompress.unzip @dir, @file
        when ".tar", ".xz"
            Decompress.done @file if Decompress.untar @dir, @file
        when ".tgz", ".gz"
            Decompress.done @file if Decompress.ungz @dir, @file
        when ".7z"
            Decompress.done @file if Decompress.un7z @dir, @file
        else
            if @file.end_with? "initrd"
                Decompress.done @file if Decompress.uncpio @dir, @file
            else
                puts "unknown compress format for: #{@file}"
            end
        end
    end
end

# list = ["cache/ubuntu-base-22.04-base-amd64.tar.gz", "1.a.tgz", "2.tar.xz", "3.c.zip", "4.d.tgz", "5.e.7z"]

# for f in list
#     d = Decompress.new "testdir", f
#     d.matcher
# end

if __FILE__ == $0
    d = Decompress.new "temp/test", "cache/initrd"
    d.matcher
end
