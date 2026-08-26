{ configs, pkgs, inputs, ... }:
{
	boot.supportedFilesystems = [ "nfs" ];
	fileSystems."/mnt/vanasa" = {
		fsType = "nfs";
		device = "10.0.0.99:/mnt/vdev1/Shared";
		options = [ "x-systemd.automount" "noauto" ];
	};

	fileSystems."/mnt/jellyfin" = {
		fsType = "nfs";
		device = "10.0.0.99:/mnt/vdev1/Media";
		options = [ "x-systemd.automount" "noauto" ];
	};	

	environment.systemPackages = with pkgs; [
		nfs-utils
	];
}
