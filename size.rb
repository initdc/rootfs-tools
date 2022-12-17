# frozen_string_literal: true

class Size
    @ratio = 4
    @block_size = 4096

    def initialize(temp_rootfs_dir, extra_inode, extra_size_MB, *rootfs_dev)
        @rDir = temp_rootfs_dir.to_s || ""
        @eInode = extra_inode.to_i || 0
        @eSizeM = extra_size_MB.to_i || 0
        @rDev = rootfs_dev[0].to_s || ""
    end

    class << self
        def BtoK(size)
            return size / 1024
        end

        def KtoM(size)
            return size / 1024
        end

        def MtoG(size)
            return size / 1024
        end

        # sudo tune2fs -l /dev/nvme0n1p4
        #
        # Blocks per group:         32768
        # Inodes per group:         8192
        #
        # 4 = 32768 / 8192
        def InodeToBlock(inode)
            return inode * @ratio
        end

        # Block size:               4096
        def BlockToB(block)
            return block * @block_size
        end

        def BlockToK(block)
            return BtoK(BlockToB(block))
        end

        def InodeToK(inode)
            return BlockToK(InodeToBlock(inode))
        end

        def BlockToM(block)
            return KtoM(BlockToK(block))
        end

        def InodeToM(inode)
            return KtoM(InodeToK(inode))
        end

        # sudo find . -printf "%h\n" | cut -d / -f -2 | sort | uniq -c | sort -rn
        def DirInode(dir)
            output = `sudo find #{dir}/.. -printf "%h\n" | cut -d / -f -2 | sort | uniq -c | sort -rn | grep #{dir}`
            inode = output.split(" ").first
            # puts inode
            return inode.to_i
        end

        def DirSizeK(dir)
            output = `sudo du -d0 #{dir}`
            size = output.split(" ").first
            # puts size
            return size.to_i
        end

        def DirSizeM(dir)
            return KtoM(DirSizeK(dir))
        end

        def DirInodeK(dir)
            result = InodeToK(DirInode(dir))
            # puts result
            return result
        end

        def DirInodeM(dir)
            return KtoM(DirInodeK(dir))
        end

        def Bigger(num_a, num_b)
            return num_a if num_a >= num_b

            return num_b
        end
    end

    def GetRatio
        if @rDev.empty?
            puts "missing disk device ARG"
            return false
        end

        output1 = `sudo tune2fs -l #{@rDev} | grep 'Blocks per group'`
        output2 = `sudo tune2fs -l #{@rDev} | grep 'Inodes per group'`

        return false if output1.empty? or output2.empty?

        blocks = output1.split(" ").last
        inodes = output2.split(" ").last
        ratio = blocks.to_i.fdiv(inodes.to_i)
        # puts ratio
        return ratio
    end

    def GetBlockSize
        if @rDev.empty?
            puts "missing disk device ARG"
            return false
        end

        output = `sudo tune2fs -l #{@rDev} | grep 'Block size'`
        return false if output.empty?

        size = output.split(" ").last
        # puts size
        return size.to_i
    end

    def GetSize
        unless @rDev.empty?
            @ratio = self.GetRatio || @ratio
            @block_size = self.GetBlockSize || @block_size
        end

        if @rDir.empty?
            puts "missing directory ARG"
            return false
        end

        rInode = Size.DirInode @rDir
        rSizeM = Size.DirSizeM @rDir

        aInodeM = Size.InodeToM(rInode + @eInode)
        aSizeM = rSizeM + @eSizeM

        # puts aInodeM
        return Size.Bigger(aInodeM.ceil(-1), aSizeM.ceil(-1))
    end
end

# dir = "ub-22"
# dev = ""

# s = Size.new dir, 100, 100

# puts s.GetRatio
# puts s.GetBlockSize
# puts s.GetSize

# for n in 1..10
#     s = Size.new "", 0, 0, "/dev/mmcblk0p#{n}"
#     puts "/dev/mmcblk0p#{n}  #{s.GetRatio}"
# end

# sudo ruby size.rb 2>/dev/null
