### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers

### AnyKernel setup
# global properties
properties() { '
kernel.string=Lineaged Kernel Installer
do.devicecheck=1
do.modules=0
do.systemless=0
do.cleanup=1
do.cleanuponabort=1
device.name1=rosy
device.name2=Redmi 5
'; } # end properties


### AnyKernel install
## boot files attributes
boot_attributes() {
set_perm_recursive 0 0 755 644 $RAMDISK/*;
set_perm_recursive 0 0 750 750 $RAMDISK/init* $RAMDISK/sbin;
} # end attributes

# boot shell variables
BLOCK=auto;
IS_SLOT_DEVICE=0;
RAMDISK_COMPRESSION=auto;
PATCH_VBMETA_FLAG=auto;

# import functions/variables and setup patching - see for reference (DO NOT REMOVE)
. tools/ak3-core.sh;

# boot install
dump_boot; # use split_boot to skip ramdisk unpack, e.g. for devices with init_boot ramdisk

# Clean up other kernels' ramdisk files before installing ramdisk
rm -rf /vendor/etc/init/hw/init.lineaged.rc

#Lineaged======================================== Credits @NFS-Projects
cp -rpf $home/ramdisk/init.lineaged.rc /vendor/etc/init/hw/init.lineaged.rc
chmod 644 /vendor/etc/init/hw/init.lineaged.rc
#spectrum write
if [ -e /system/etc/init/hw/init.rc ]; then
	cp -rpf /system/etc/init/hw/init.rc~ /system/etc/init/hw/init.rc
		remove_line /system/etc/init/hw/init.rc "import /vendor/etc/init/hw/init.lineaged.rc";
		backup_file /system/etc/init/hw/init.rc;
		insert_line /system/etc/init/hw/init.rc "init.lineaged.rc" before "import /init.environ.rc" "import /vendor/etc/init/hw/init.lineaged.rc";
fi;

if [ -e /vendor/etc/init/hw/init.qcom.rc ]; then
	cp -rpf /vendor/etc/init/hw/init.qcom.rc~  /vendor/etc/init/hw/init.qcom.rc
		remove_line /vendor/etc/init/hw/init.qcom.rc "import /vendor/etc/init/hw/init.lineaged.rc";
		backup_file /vendor/etc/init/hw/init.qcom.rc;
		insert_line /vendor/etc/init/hw/init.qcom.rc "init.lineaged.rc" before "import /vendor/etc/init/hw/init.qcom.usb.rc" "import /vendor/etc/init/hw/init.lineaged.rc";
fi;
#Lineaged========================================

rm -rf /system/etc/init/hw/init.rc~
rm -rf /vendor/etc/init/hw/init.qcom.rc~

write_boot; # use flash_boot to skip ramdisk repack, e.g. for devices with init_boot ramdisk
## end boot install


## init_boot files attributes
#init_boot_attributes() {
#set_perm_recursive 0 0 755 644 $RAMDISK/*;
#set_perm_recursive 0 0 750 750 $RAMDISK/init* $RAMDISK/sbin;
#} # end attributes

# init_boot shell variables
#BLOCK=init_boot;
#IS_SLOT_DEVICE=1;
#RAMDISK_COMPRESSION=auto;
#PATCH_VBMETA_FLAG=auto;

# reset for init_boot patching
#reset_ak;

# init_boot install
#dump_boot; # unpack ramdisk since it is the new first stage init ramdisk where overlay.d must go

#write_boot;
## end init_boot install


## vendor_kernel_boot shell variables
#BLOCK=vendor_kernel_boot;
#IS_SLOT_DEVICE=1;
#RAMDISK_COMPRESSION=auto;
#PATCH_VBMETA_FLAG=auto;

# reset for vendor_kernel_boot patching
#reset_ak;

# vendor_kernel_boot install
#split_boot; # skip unpack/repack ramdisk, e.g. for dtb on devices with hdr v4 and vendor_kernel_boot

#flash_boot;
## end vendor_kernel_boot install


## vendor_boot files attributes
#vendor_boot_attributes() {
#set_perm_recursive 0 0 755 644 $RAMDISK/*;
#set_perm_recursive 0 0 750 750 $RAMDISK/init* $RAMDISK/sbin;
#} # end attributes

# vendor_boot shell variables
#BLOCK=vendor_boot;
#IS_SLOT_DEVICE=1;
#RAMDISK_COMPRESSION=auto;
#PATCH_VBMETA_FLAG=auto;

# reset for vendor_boot patching
#reset_ak;

# vendor_boot install
#dump_boot; # use split_boot to skip ramdisk unpack, e.g. for dtb on devices with hdr v4 but no vendor_kernel_boot

#write_boot; # use flash_boot to skip ramdisk repack, e.g. for dtb on devices with hdr v4 but no vendor_kernel_boot
## end vendor_boot install

