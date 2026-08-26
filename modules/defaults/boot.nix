{ config, pkgs, ...}:
{
	nix.settings.experimental-features = [ "nix-command" "flakes" ];
	nixpkgs.config.allowUnfree = true;
	boot = {
		loader.systemd-boot.enable = true;
		loader.efi.canTouchEfiVariables = true;
		kernelPackages = pkgs.linuxPackages_latest;
	};	
}
