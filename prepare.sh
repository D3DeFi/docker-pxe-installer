#!/bin/bash

# This is the IP address that will be advertised in PXE configuration and installed server will attempt to download ISO
# and ubuntu installer configuration from it. Make sure it is IP address that server will be able to reach after addressed by DHCP
LISTENIP=192.168.56.2:8080

ISO_URL=http://releases.ubuntu.com/focal/
ISO=ubuntu-20.04.2-live-server-amd64.iso
PXELINUX=http://archive.ubuntu.com/ubuntu/dists/focal/main/installer-amd64/current/legacy-images/netboot/pxelinux.0
LDLINUX=http://archive.ubuntu.com/ubuntu/dists/focal/main/installer-amd64/current/legacy-images/netboot/ldlinux.c32

# Create directories
echo "creating directories..."
test -d web || mkdir web
test -d tftp || mkdir tftp

# Download ISO
echo "downloading ISO..."
test -f web/$ISO || wget ${ISO_URL}/${ISO} -O web/$ISO -q --show-progress

# Mount ISO and get initrd & vmlinuz so machine can boot to it
echo "retrieving vmlinuz and initrd from ISO..."
mkdir tmp-mnt
mount -o loop,ro web/$ISO tmp-mnt/
cp tmp-mnt/casper/{vmlinuz,initrd} tftp/
umount tmp-mnt/
rmdir tmp-mnt

# Get additional required files
echo "downloading pxelinux.0 and ldlinux.c32..."
wget $PXELINUX -O tftp/pxelinux.0 -q --show-progress
wget $LDLINUX -O tftp/ldlinux.c32 -q --show-progress

# Create default pxelinux configuration to direct servers to installer with cloud-init-bios
echo "generating pxelinux.cfg/default..."
test -d tftp/pxelinux.cfg || mkdir tftp/pxelinux.cfg

cat <<EOF > tftp/pxelinux.cfg/default
DEFAULT install
LABEL install
  KERNEL vmlinuz
  INITRD initrd
  APPEND root=/dev/ram0 ramdisk_size=1500000 ip=dhcp url=http://${LISTENIP}/${ISO} autoinstall ds=nocloud-net;s=http://${LISTENIP}/cloud-init-bios/
EOF
