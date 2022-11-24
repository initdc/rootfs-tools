#!/bin/sh

# https://www.cnblogs.com/shineshqw/articles/2336842.html
# https://linuxconfig.org/how-to-create-and-extract-cpio-archives-on-linux-examples

find initrd/ -depth -print0 | cpio -ocv0 | gzip -9 > temp/initrd
