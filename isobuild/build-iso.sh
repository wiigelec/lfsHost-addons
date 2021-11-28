#!/bin/bash

xorrisofs -o /mnt/hold/iso/lfsHostXXX.iso \
-b isolinux/isolinux.bin -c isolinux/boot.cat \
-no-emul-boot -boot-load-size 4 -boot-info-table \
/mnt/iso
