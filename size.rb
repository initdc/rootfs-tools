class Size 
    @@ratio = 4
    @@block_size = 4096

    def initialize temp_rootfs_dir, extra_inode, extra_size_MB, rootfs_dev
        @rDir = temp_rootfs_dir
        @eInode = extra_inode
        @eSizeM = extra_size_MB
        @rDev = rootfs_dev
    end

    class << self
        def BtoK size
            return size / 1024
        end

        def KtoM size
            return size / 1024
        end

        def MtoG size
            return size / 1024
        end

        # sudo tune2fs -l /dev/nvme0n1p4
        # 
        # Blocks per group:         32768
        # Inodes per group:         8192
        #
        # 4 = 32768 / 8192
        def InodeToBlock inode
            return inode * @@ratio
        end

        # Block size:               4096
        def BlockToB block
            return block * @@block_size
        end

        def BlockToK block
            return BtoK(BlockToB(block))
        end

        def InodeToK inode
            return BlockToK(InodeToBlock(inode))
        end

        def BlockToM block
            return KtoM(BlockToK(block))
        end

        def InodeToM inode
            return KtoM(InodeToK(inode))
        end

        # sudo find . -printf "%h\n" | cut -d / -f -2 | sort | uniq -c | sort -rn
        def DirInode dir 
            output = `sudo find . -printf "%h\n" | cut -d / -f -2 | sort | uniq -c | sort -rn | grep #{dir}`
            inode = output.split(" ").first
            # puts inode
            return inode.to_i
        end

        def DirSizeK dir
            output = `sudo du -d0 #{dir}`
            size = output.split(" ").first
            # puts size
            return size.to_i
        end

        def DirSizeM dir
            return KtoM(DirSizeK(dir))
        end

        def DirInodeK dir
            result = InodeToK(DirInode(dir))
            # puts result
            return result
        end

        def DirInodeM dir
            return KtoM(DirInodeK(dir))
        end

        def Bigger a, b
            return a if a >= b
            return b
        end
    end

    def GetRatio
        output = `sudo tune2fs -l #{@rDev} | grep 'Blocks per group'`
        blocks = output.split(" ").last

        output = `sudo tune2fs -l #{@rDev} | grep 'Inodes per group'`
        inodes = output.split(" ").last

        ratio = blocks.to_i.fdiv(inodes.to_i)

        # puts ratio
        return ratio
    end

    def GetBlockSize
        output = `sudo tune2fs -l #{@rDev} | grep 'Block size'`
        size = output.split(" ").last

        # puts size
        return size.to_i
    end

    def GetSize
        @@ratio = self.GetRatio || @@ratio
        @@block_size = self.GetBlockSize || @@block_size

        rInode =  Size.DirInode @rDir
        rSizeM = Size.DirSizeM @rDir

        aInodeM = Size.InodeToM(rInode + @eInode)
        aSizeM = rSizeM + @eSizeM

        # puts aInodeM
        return Size.Bigger(aInodeM.ceil(-1), aSizeM.ceil(-1))
    end
end

# dir = "/root"
# dev = "/dev/sda1"

# s = Size.new dir, 100, 100, dev

# puts s.GetRatio
# puts s.GetBlockSize
# puts s.GetSize
