#!/bin/sh

#-------------------------------------------------------------------
# Clean files

echo "Cleaning lfsHost-build files from /mnt/lfs..."

# /home/(blfs-)builder
rm -rf /mnt/lfs/home/builder/
rm -rf /mnt/lfs/home/blfs-builder

# /jhalfs
rm -rf /mnt/lfs/jhalfs

# /root
rm /mnt/lfs/root/build-kernel.sh
rm /mnt/lfs/root/kernel-config.*
rm /mnt/lfs/root/lfs-chroot.sh
rm /mnt/lfs/root/lfs-umount.sh
rm -rf /mnt/lfs/root/blfs_root

# /sources
rm -rf /mnt/lfs/sources/

# /var/lib/jhalfs
rm -rf /mnt/lfs/var/lib/jhalfs

# /
rm /mnt/lfs/README.md

# logs
echo "Truncating /mnt/lfs log files..."
find /mnt/lfs/var/log -type f -iname '*.log' -print0 | xargs -0 truncate -s0

echo "Done."

# END script
#-------------------------------------------------------------------
