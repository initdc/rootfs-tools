# rootfs-tools

> build workflow for rootfs images

## Prepare

```
sudo apt update
sudo apt install $(cat dep.txt)

sudo systemctl enable --now libvirtd
```

ref: https://wiki.gentoo.org/wiki/RISC-V_Qemu_setup

## Run

```
sudo ruby main.rb
```

But it may be not fit to you, just run `CMD` in the scripts.

## More

### why qemu?

`qemu-user-static` for cross-arch chroot supporting,

like you need `qemu-aarch64` runing an `aarch64` binary on x86_64 host.

### Guide

- Image

  Build which kind of disk image (single partition or combined image) deps the devkit needs.

  You can just edit the origin disk image if disk space is ok.

  Otherwise you may need create a new blank image by `dd`.

  Combined image aslo can be created by `dd`, you just need load disk layout file by `fdisk`.

- Porting

  Porting linux distro, you need the `kernel` `firmware` `fstab` etc, so backup them first of all.

  Then copy the prebuilt linux distro `root` files.

  After file operation, you may need some configuration, like user password, extra software.

  Then flash it, boot it, debug it, re-edit someting...

## Wishing

It's pretty easy task after this tool handling some **dirty work**, so have fun!

## License

MPL-2.0
