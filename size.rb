class Size
    def initialize temp_rootfs_dir, extra_inode, extra_size_MB
        @rDir = temp_rootfs_dir
        @eInode = extra_inode
        @eSizeM = extra_size_MB
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
            return inode * 4
        end    

        # Block size:               4096
        def BlockToB block
            return block * 4096
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

    def GetSize 
        rInode =  Size.DirInode @rDir
        rSizeM = Size.DirSizeM @rDir

        aInodeM = Size.InodeToM(rInode + @eInode)
        aSizeM = rSizeM + @eSizeM

        # puts aInodeM
        return Size.Bigger(aInodeM.ceil(-2), aSizeM.ceil(-2))
    end
end

# dir = "ub-22"
# s = Size.new dir, 100, 100
# puts s.GetSize