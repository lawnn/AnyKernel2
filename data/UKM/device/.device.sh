#!/system/bin/sh

UKM=/data/UKM;
BB=$UKM/busybox;
DEVPROP="ro.product.device";
DEVICE=`getprop "$DEVPROP" 2> /dev/null`;

if [ -z "$DEVICE" ]; then DEVICE=`$BB grep "$DEVPROP=" /system/build.prop | $BB cut -d= -f2`; fi;

#Official
case $DEVICE in
	d800|d801|d802|d803|ls980|vs980)
		CONFIG="galbi";; #LG G2
esac;

if [ -n "$CONFIG" ]; then PATH="$UKM/device/$CONFIG.sh"; else PATH=""; fi;

$BB echo "$PATH";
