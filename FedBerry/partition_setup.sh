#!/bin/sh

set -ex

if [ -z "$part1" ] || [ -z "$part2" ]; then
  printf "Error: missing environment variable part1 or part2\n" 1>&2
  exit 1
fi

mkdir -p /tmp/1

mount "$part1" /tmp/1
sed /tmp/1/cmdline.txt -i -e "s|root=[^ ]*|root=${part2}|"
sed /tmp/1/cmdline.txt -i -e "s|logo.nologo|logo.nologo selinux=1 security=selinux enforcing=0|"
sed /tmp/1/grub/grub.conf -i -e "s|root=[^ ]*|root=${part2}|"
umount /tmp/1

mount "$part2" /tmp/1
sed /tmp/1/etc/fstab -i -e "s|^.* / |${part2}  / |"
sed /tmp/1/etc/fstab -i -e "s|^.* /boot |${part1}  /boot |"
rm -r /tmp/1/.rootfs-repartition
umount /tmp/1
