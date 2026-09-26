{ config, pkgs, lib, ... }:
{
	imports = [
		../../modules/sops.nix
	];
	
	sops.age.keyFile = lib.mkForce "/home/admin/.config/sops/age/keys.txt";

	services.openssh.settings.AllowUsers = [ "admin" "vanasa" ];

	sops.secrets = {
		"admin/passwordHash".neededForUsers = true;
		"vanasa/passwordHash".neededForUsers = true;
	};
	
	users.groups.admin = {
		gid = 1000;
	};
	
	users.groups.vanasa = {
		gid = 3000;
	};

	# High-privilege user for system admin
	users.users.admin = {
		isNormalUser = true;
		description = "Admin";
		uid = 1000;
		group = "admin";
		extraGroups = [ "vanasa" "jellyfin" "docker" "networkmanager" "wheel" ];
		packages = with pkgs; [
		];

		openssh.authorizedKeys.keys = [
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH+G3FP97UOUc2SpMHtXOX0+8RwVsT99OntbS7gdzMBv jade@Ryzen-Desktop" # Mint-Desktop
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGk8iiJUsUpaxWnJc0PRIneTrt0Oz8fHgR2+5wDuwURf jade@lopen"
		];

		hashedPasswordFile = config.sops.secrets."admin/passwordHash".path;
	};

	# Low-privilege user for shares
	users.users.vanasa = {
		isNormalUser = true;
		description = "vanasa";
		uid = 3000; # keep same uid as vanasa on truenas
		group = "vanasa";
		openssh.authorizedKeys.keys = [
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFtiSdfFJ3zCLbrnsaMt81YSH9cKWEpPxm+pSSDn9eOY jade@lopen"
		];
		hashedPasswordFile = config.sops.secrets."vanasa/passwordHash".path;
	};
}
