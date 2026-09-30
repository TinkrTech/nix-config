{ config, pkgs, lib, ... }:
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
	hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
		version = "580.142";
		sha256_64bit = "sha256-IJFfzz/+icNVDPk7YKBKKFRTFQ2S4kaOGRGkNiBEdWM=";
		sha256_aarch64 = "sha256-IJFfzz/+icNVDPk7YKBKKFRTFQ2S4kaOGRGkNiBEdWM=";
		openSha256 = "sha256-BnrIlj5AvXTfqg/qcBt2OS9bTDDZd3uhf5jqOtTMTQM=";
		settingsSha256 = "sha256-BnrIlj5AvXTfqg/qcBt2OS9bTDDZd3uhf5jqOtTMTQM=";
		persistencedSha256 = lib.fakeSha256;
	};
}
