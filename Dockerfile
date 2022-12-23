FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

RUN set -e \
    && sed -i "s/# deb-src/deb-src/g" /etc/apt/sources.list \
    && apt-get update

RUN set -e \
    && apt-get install --no-install-recommends -y \
    sudo

RUN useradd -c 'ubuntu' -m -d /home/ubuntu -s /bin/bash ubuntu
RUN set -e \
    && sed -i '/\%sudo/ c \%sudo ALL=(ALL) NOPASSWD: ALL' /etc/sudoers \
    && usermod -aG sudo ubuntu

RUN set -e \
    && apt-get install --no-install-recommends -y \

    # Project
    git-core \
    ruby \
    qemu-user-static \
    libvirt-daemon-system \

    # compress.rb
    xz-utils \

    # copy.rb

    # decompress.rb
    unzip \
    p7zip-full \
    zstd \
    cpio \

    # fetch.rb
    wget \

    # main.rb

    # mount.rb
    fdisk

    # resize.rb

    # size.rb

USER ubuntu
WORKDIR /home/ubuntu/

ENTRYPOINT ["/bin/bash"]