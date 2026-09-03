{ config, pkgs, ...}:
{
	boot.supportedFilesystems = [ "zfs" ];
	boot.zfs.extraPools = [ "vdev1" ];
	fileSystems."/mnt/vdev1" = {
		device = "vdev1";
		fsType = "zfs";
	};
	
	services.zfs = {
		autoScrub = {
			enable = true;
			# Run scrub every Monday at midnight 
			# See https://wiki.archlinux.org/title/Systemd/Timers#Realtime_timer
			interval = "weekly";
		};
		autoTrim.enable = true;
		# TODO: snapshots for
		# - vdev1/configs every week and keep for 1 month
		# - vdev1/Photos every day and keep for 1 week
		# - vdev1/Shared every day and keep for 2 weeks
	};
}
