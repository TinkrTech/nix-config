{ config, pkgs, inputs, ... }:
{
	imports = [ 
		./hardware-configuration.nix
		../../modules/defaults/boot.nix
		../../modules/defaults/locale.nix
		../../modules/defaults/nixvim.nix
		../../modules/defaults/utils.nix
		../../modules/ssh.nix
		../../modules/sops.nix
	];

	# Disbale printing service from utils.nix
	services.printing.enable = false;
	services.openssh.settings.AllowUsers = [ "admin" "vanasa" ];

	sops.secrets = {
		"admin/passwordHash".neededForUsers = true
		"vanasa/passwordHash".neededForUsers = true;
	};

	users.users.admin = {
		isNormalUser = true;
		description = "Admin";
		extraGroups = [ "docker" "networkmanager" "wheel" ];
		packages = with pkgs; [
		];

		openssh.authorizedKeys = [
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH+G3FP97UOUc2SpMHtXOX0+8RwVsT99OntbS7gdzMBv jade@Ryzen-Desktop" # Mint-Desktop
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGk8iiJUsUpaxWnJc0PRIneTrt0Oz8fHgR2+5wDuwURf jade@lopen"
		];

		hashedPassword = config.sops.secrets."admin/passwordHash".path;
	};
	
	users.users.vanasa = {
		isNormalUser = true;
		description = "vanasa";
		
		openssh.authorizedKeys = [
			# Mint-Desktop
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFtiSdfFJ3zCLbrnsaMt81YSH9cKWEpPxm+pSSDn9eOY jade@lopen"
		];
		hashedPassword = config.sops.secrets."vanasa/passwordHash".path;
	};
	
	
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
