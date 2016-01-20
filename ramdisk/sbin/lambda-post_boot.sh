#!/system/bin/sh

BB=/sbin/bb/busybox

############################
# Custom Kernel Settings for Lambda Kernel!
#
echo "[Lambda Kernel] Boot script started" | tee /dev/kmsg
stop mpdecision

############################
# MSM_Hotplug Settings
#
#echo "[Lambda Kernel] Tunning MSM Hotplug values" | tee /dev/kmsg
#echo 1 > /sys/module/msm_hotplug/min_cpus_online
#echo 2 > /sys/module/msm_hotplug/cpus_boosted
#echo 500 > /sys/module/msm_hotplug/down_lock_duration
#echo 3000 > /sys/module/msm_hotplug/boost_lock_duration
#echo 200 5:100 50:50 350:200 > /sys/module/msm_hotplug/update_rates
#echo 100 > /sys/module/msm_hotplug/fast_lane_load
#echo 1 > /sys/module/msm_hotplug/max_cpus_online_susp

############################
# MSM_MPDecision (Bricked) Hotplug Settings
#
#echo 652800 > /sys/kernel//msm_mpdecision/conf/idle_freq

############################
# CPU-Boost Settings
#
#echo "[Lambda Kernel] Setting boost parameters" | tee /dev/kmsg
#echo 20 > /sys/module/cpu_boost/parameters/boost_ms
#echo 500 > /sys/module/cpu_boost/parameters/input_boost_ms
#echo 0:1497600 1:1497600 2:1497600 3:1497600 > /sys/module/cpu_boost/parameters/input_boost_freq
#echo 1728000 > /sys/module/cpu_boost/parameters/sync_threshold
#echo 25 > /sys/module/cpu_boost/parameters/migration_load_threshold
#echo 1 > /sys/module/cpu_boost/parameters/hotplug_boost
#echo 1 > /sys/module/cpu_boost/parameters/wakeup_boost

############################
# Tweak Background Writeout
#
echo 200 > /proc/sys/vm/dirty_expire_centisecs
echo 40 > /proc/sys/vm/dirty_ratio
echo 5 > /proc/sys/vm/dirty_background_ratio
echo 10 > /proc/sys/vm/swappiness
echo 50 > /proc/sys/vm/vfs_cache_pressure

############################
# Power Effecient Workqueues
#
#echo 1 > /sys/module/workqueue/parameters/power_efficient

############################
# MSM Limiter
#
echo "[Lambda Kernel] Setting CPU clocks" | tee /dev/kmsg
echo 300000 > /sys/kernel/msm_limiter/suspend_min_freq_0
echo 300000 > /sys/kernel/msm_limiter/suspend_min_freq_1
echo 300000 > /sys/kernel/msm_limiter/suspend_min_freq_2
echo 300000 > /sys/kernel/msm_limiter/suspend_min_freq_3
echo 2265600 > /sys/kernel/msm_limiter/resume_max_freq_0
echo 2265600 > /sys/kernel/msm_limiter/resume_max_freq_1
echo 2265600 > /sys/kernel/msm_limiter/resume_max_freq_2
echo 2265600 > /sys/kernel/msm_limiter/resume_max_freq_3
#echo 1190400 > /sys/kernel/msm_limiter/suspend_max_freq

############################
# Scheduler and Read Ahead
#
#echo fiops > /sys/block/mmcblk0/queue/scheduler
echo 1024 > /sys/block/mmcblk0/bdi/read_ahead_kb

############################
# Governor Tunings
#

# Intrusive interactive tweaks
echo "[Lambda Kernel] Tunning interactive governor" | tee /dev/kmsg
echo interactive > /sys/kernel/msm_limiter/scaling_governor_0
echo interactive > /sys/kernel/msm_limiter/scaling_governor_1
echo interactive > /sys/kernel/msm_limiter/scaling_governor_2
echo interactive > /sys/kernel/msm_limiter/scaling_governor_3
echo 20000 1400000:40000 1700000:20000 > /sys/devices/system/cpu/cpufreq/interactive/above_hispeed_delay
echo 90 > /sys/devices/system/cpu/cpufreq/interactive/go_hispeed_load
echo 1190400 > /sys/devices/system/cpu/cpufreq/interactive/hispeed_freq
echo 1 > /sys/devices/system/cpu/cpufreq/interactive/io_is_busy
echo 85 1500000:90 1800000:70 > /sys/devices/system/cpu/cpufreq/interactive/target_loads
echo 40000 > /sys/devices/system/cpu/cpufreq/interactive/min_sample_time
echo 30000 > /sys/devices/system/cpu/cpufreq/interactive/timer_rate
echo 100000 > /sys/devices/system/cpu/cpufreq/interactive/max_freq_hysteresis
echo 30000 > /sys/devices/system/cpu/cpufreq/interactive/timer_slack

# Intrusive smartmax tweaks
#echo "[Lambda Kernel] Tunning smartmax governor" | tee /dev/kmsg
#echo 729600 > /sys/devices/system/cpu/cpufreq/smartmax/suspend_ideal_freq
#echo 1036800 > /sys/devices/system/cpu/cpufreq/smartmax/awake_ideal_freq
#echo 1 > /sys/devices/system/cpu/cpufreq/smartmax/io_is_busy
#echo 70 > /sys/devices/system/cpu/cpufreq/smartmax/max_cpu_load
#echo 30 > /sys/devices/system/cpu/cpufreq/smartmax/min_cpu_load
#echo 1497600 > /sys/devices/system/cpu/cpufreq/smartmax/touch_poke_freq
#echo 1497600 > /sys/devices/system/cpu/cpufreq/smartmax/boost_freq

############################
# LMK Tweaks
#
#echo "[Lambda Kernel] Setting LMK values" | tee /dev/kmsg
#echo 1536,2048,4096,16384,28672,32768 > /sys/module/lowmemorykiller/parameters/minfree
#echo 32 > /sys/module/lowmemorykiller/parameters/cost
#echo 1 > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk
#echo 53059 > /sys/module/lowmemorykiller/parameters/vmpressure_file_min

############################
# Misc Tweaks
#
#echo 0 > /sys/kernel/sched/gentle_fair_sleepers
#echo 1 > /sys/module/adreno_idler/parameters/adreno_idler_active
#echo 1 > /dev/cpuctl/cpu.notify_on_migrate

############################
# Disable Debugging
#
echo "[Lambda Kernel] Disabling debug mask" | tee /dev/kmsg
echo "0" > /sys/module/kernel/parameters/initcall_debug;
echo "0" > /sys/module/alarm_dev/parameters/debug_mask;
echo "0" > /sys/module/binder/parameters/debug_mask;
echo "0" > /sys/module/xt_qtaguid/parameters/debug_mask;
echo "0" > /sys/module/lge_touch_core/parameters/debug_mask

############################
# Init.d Support
#
/sbin/busybox run-parts /system/etc/init.d

############################
# SuperUser Tweaks (TESTING)
# Allow untrusted apps to read from debugfs
if [ -e /system/lib/libsupol.so ]; then
/system/xbin/supolicy --live \
	"allow untrusted_app debugfs file { open read getattr }" \
	"allow untrusted_app sysfs_lowmemorykiller file { open read getattr }" \
	"allow untrusted_app sysfs_usb_supply dir { search }" \
	"allow untrusted_app persist_file dir { open read getattr }" \
	"allow debuggerd gpu_device chr_file { open read getattr }" \
	"allow netd netd capability fsetid" \
	"allow netd { hostapd dnsmasq } process fork" \
	"allow { system_app shell } dalvikcache_data_file file write" \
	"allow { zygote mediaserver bootanim appdomain }  theme_data_file dir { search r_file_perms r_dir_perms }" \
	"allow { zygote mediaserver bootanim appdomain }  theme_data_file file { r_file_perms r_dir_perms }" \
	"allow system_server { rootfs resourcecache_data_file } dir { open read write getattr add_name setattr create remove_name rmdir unlink link }" \
	"allow system_server resourcecache_data_file file { open read write getattr add_name setattr create remove_name unlink link }" \
	"allow system_server dex2oat_exec file rx_file_perms" \
	"allow mediaserver mediaserver_tmpfs file execute" \
	"allow drmserver theme_data_file file r_file_perms" \
	"allow zygote system_file file write" \
	"allow atfwd property_socket sock_file write" \
	"allow debuggerd app_data_file dir search"
fi;

############################
# Google Services battery drain fixer by Alcolawl@xda
#
pm enable com.google.android.gms/.update.SystemUpdateActivity
pm enable com.google.android.gms/.update.SystemUpdateService
pm enable com.google.android.gms/.update.SystemUpdateService$ActiveReceiver
pm enable com.google.android.gms/.update.SystemUpdateService$Receiver
pm enable com.google.android.gms/.update.SystemUpdateService$SecretCodeReceiver
pm enable com.google.android.gsf/.update.SystemUpdateActivity
pm enable com.google.android.gsf/.update.SystemUpdatePanoActivity
pm enable com.google.android.gsf/.update.SystemUpdateService
pm enable com.google.android.gsf/.update.SystemUpdateService$Receiver
pm enable com.google.android.gsf/.update.SystemUpdateService$SecretCodeReceiver

echo "[Lambda Kernel] Boot script completed" | tee /dev/kmsg
