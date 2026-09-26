{ config, pkgs, ... }:
{
	nixpkgs.config.nvidia.acceptLicense = true;
	hardware.graphics.enable = true;
	services.xserver.videoDrivers = [ "nvidia" ];
	hardware.nvidia = {
		modesetting.enable = true;
		open = false;
		nvidiaSettings = true;
		# Below is commented out since it seems to cause there to be no display at all
		# Whereas with the modern drivers it at least renders the tty correctly
		# package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
	};
}
