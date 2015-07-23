#!/sbin/sh
#
# /sbin/sh flashimg.sh [ -zimage_only ] boot_path [ aboot_path_for_loki ]
#

if [ -d "/data/local/tmp/" ]; then
  log_file=/data/local/tmp/flashimg.log
  rm -f "$log_file"
else
  log_file=/dev/stdout
fi
log() { echo "$1" >> "$log_file"; }
abort() { log "$1"; exit 1; }
cleanup() { rm -rf ramdisk* split_img* *new.* *.img; }

if [ "$1" = "-zimage_only" ]; then
  zimage_only=true
  shift
else
  zimage_only=false
fi

if [ $# -lt 1 ]; then
  abort "** no boot partition specified"
else
  boot_path="$1"
fi
if [ $# -ge 2 ]; then
  aboot_path="$2"
fi

D=/tmp/flash_boot
cd $D || abort $D": No such directory"
bin="$D/bin";
cleanup
mv /tmp/boot.img $D/boot.img

if [ "$zimage_only" != "true" ]; then
  cp boot.img newboot.img
else
  ## get original boot.img
  if [ -z "$aboot_path" ]; then
    dd if="$boot_path" of=origboot.img >> "$log_file" || abort "** no boot.img"
    log "++ get original boot.img"
  else
    # unloki
    dd if="$boot_path" of=lokiboot.img >> "$log_file" || abort "** no boot.img"
    $bin/loki_tool unlok lokiboot.img origboot.img >> "$log_file" || abort "** un-loki failed"
    rm -f lokiboot.img
    log "++ get and un-loki original boot.img"
  fi

  ## extract original ramdisk
  /sbin/sh ./unpackimg.sh origboot.img >> "$log_file" || abort "** unpack origboot.img failed"
  mv ramdisk ramdisk-orig
  rm -fr split_img
  log "++ unpack original boot.img"

  ## unpack boot.img 
  /sbin/sh ./unpackimg.sh boot.img >> "$log_file" || abort "** unpack boot.img failed"
  log "++ unpack boot.img"

  ## swap ramdisk
  mv ramdisk ramdisk-boot
  mv ramdisk-orig ramdisk
  cp -f ramdisk-boot/selinux_version ramdisk/selinux_version
  log "++ swap ramdisk"

  ## repack new boot.img
  /sbin/sh ./repackimg.sh >> "$log_file" || abort "** repack new boot.img failed"
  mv image-new.img newboot.img
  log "++ repack new boot.img"
fi

## write new boot.img
if [ -z "$aboot_path" ]; then
  dd if=newboot.img of="$boot_path" >> "$log_file" || abort "** flash boot.img failed"
  log "++ flash new boot.img"
else
  # loki
  dd if="$aboot_path" of=aboot.img >> "$log_file" || abort "** no aboot.img"
  $bin/loki_tool patch boot aboot.img newboot.img newboot.lok >> "$log_file" || abort "** loki patch failed"
  $bin/loki_tool flash boot newboot.lok >> "$log_file" || abort "** loki flash failed"
  rm -f aboot.img newboot.lok
  log "++ loki and flash new boot.img"
fi

exit 0
