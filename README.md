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

## License

MPL-2.0