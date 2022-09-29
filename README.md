# rootfs-tools
> build workflow for rootfs images

## Prepare

```
sudo apt install ruby wget qemu-user-static qemu qemu-kvm libvirt-clients libvirt-daemon-system bridge-utils virtinst libvirt-daemon

sudo systemctl enable --now libvirtd
```
ref: https://www.how2shout.com/linux/how-to-install-qemu-kvm-on-ubuntu-22-04-20-04-lts/

## Run

```
sudo ruby main.rb
```

But it may be not fit to you, just run `CMD` in the scripts.

## License

MPL-2.0