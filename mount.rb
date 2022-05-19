def mountImage img, path
	puts "mounting image #{img} on #{path}"
	`mount -o loop #{img} #{path}`
end

def unmountImage path
	puts "unmounting image on #{path}"
	`umount #{path}`
end

def mountDev path
	puts "mounting /dev on  #{path}"
	`mount -t proc /proc #{path}/proc`
	`mount -t sysfs /sys #{path}/sys`
	`mount -o bind /dev #{path}/dev`
	`mount -o bind /dev/pts #{path}/dev/pts`
end

def unmountDev path
	puts "unmounting /dev on #{path}"
	`umount #{path}/proc`
	`umount #{path}/sys`
	`umount #{path}/dev/pts`
	`umount #{path}/dev`
end

# img = "ubuntu-core.img"
# path = "mars-A1-ub18-core"

img = "ubuntu.img"
path = "mars-A1-ub18-gnome"

# mountImage img, path
# mountDev path

unmountDev path
puts "waiting for 3s"
sleep 3
unmountImage path
