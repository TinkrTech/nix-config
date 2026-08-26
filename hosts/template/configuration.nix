{ config, pkgs, inputs, ... }:
{
	imports = [ 
		./hardware-configuration.nix
		../../modules/defaults
		../../modules/desktop-envs/cinnamon.nix
		../../modules/nas-nfs.nix
	];
	
	users.users.jade.packages = with pkgs; [
	];

	# List packages installed in system profile. To search, run:
	# $ nix search wget
	environment.systemPackages = with pkgs; [
	];

	# This value determines the NixOS release from which the default
	# settings for stateful data, like file locations and database versions
	# on your system were taken. It‘s perfectly fine and recommended to leave
	# this value at the release version of the first install of this system.
	# Before changing this value read the documentation for this option
	# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "26.05"; # Did you read the comment?
}
