#!/bin/sh

#---------------------------------------------------------------------
# ABOUT:
# This script will setup the file system for running on bootable
# media ie cdrom or usb per the LFS hint
# https://www.linuxfromscratch.org/hints/downloads/files/boot-cd_easy.txt
#---------------------------------------------------------------------

echo "Creating portable file system on /mnt/lfs:"

#---------------------------------------------------------------------
# Install create_ramdisk startup script

echo "Installing create_ramdisk startup script..."

cat > /mnt/lfs/etc/rc.d/init.d/create_ramdisk << "EOF"
#!/bin/sh

dev_ram=/dev/ram0
dir_ramdisk=/fake/ramdisk
dir_needwrite=/fake/needwrite

. /lib/lsb/init-functions

case "$1" in
        start)
                echo -n "Creating ext2fs on $dev_ram ...              "
                /sbin/mke2fs -m 0 -i 1024 -q $dev_ram > /dev/null 2>&1
                evaluate_retval
                sleep 1
                echo -n "Mounting ramdisk on $dir_ramdisk ...         "
                mount -n $dev_ram $dir_ramdisk
                evaluate_retval
                sleep 1
                echo -n "Copying files to ramdisk ...                 "
                cp -dpR $dir_needwrite/* $dir_ramdisk > /dev/null 2>&1
                evaluate_retval
                sleep 1
                echo -n "Remount ramdisk to $dir_needwrite ...        "
                umount -n $dir_ramdisk > /dev/null 2>&1
                sleep 1
                mount -n $dev_ram $dir_needwrite
                sleep 1
                ;;
        *)
                echo "Usage: $0 {start}"
                exit 1
                ;;
esac

EOF

chmod 0755 /mnt/lfs/etc/rc.d/init.d/create_ramdisk
cd /mnt/lfs/etc/rc.d/rcS.d
ln -s ../init.d/create_ramdisk S01create_ramdisk


#---------------------------------------------------------------------
# Update fstab

echo "Updating fstab..."

rm /mnt/lfs/etc/fstab
cat > /mnt/lfs/etc/fstab << "EOF"
# Begin /etc/fstab for bootable media

# file system  mount-point  type   options         dump  fsck
#                                                        order
#/dev/EDITME     /            EDITME  defaults        1     1
#/dev/EDITME     swap         swap   pri=1           0     0
proc           /proc        proc   defaults        0     0
sysfs          /sys         sysfs  defaults        0     0
devpts         /dev/pts     devpts gid=4,mode=620  0     0
tmpfs          /dev/shm     tmpfs  defaults        0     0
tmp            /tmp         tmpfs  defaults        0     0
# End /etc/fstab
EOF


#---------------------------------------------------------------------
# Update mountfs

echo "Updating mountfs startup script..."

cd /mnt/lfs/etc/rc.d/init.d
cp -f mountfs mountfs.org
grep -v 'remount' mountfs.org >mountfs
chmod 0755 mountfs


#---------------------------------------------------------------------
# Create ramdisk symlinks

echo "Creating ramdisk fake symlinks..."

mkdir -p /mnt/lfs/fake/{needwrite,ramdisk}
cd /mnt/lfs
mv etc/ var/ root/ home/ tmp/ fake/needwrite/
ln -s fake/needwrite/etc etc
ln -s fake/needwrite/var var
ln -s fake/needwrite/root root
ln -s fake/needwrite/home home
ln -s fake/needwrite/tmp tmp

#---------------------------------------------------------------------
# Install /mnt/lfs

mkdir /mnt/lfs/mnt/lfs
mkdir /mnt/lfs/mnt/usb


echo "Done."
echo "DID YOU DISABLE SUDO PASSWD?"

# END SCRIPT
#---------------------------------------------------------------------
