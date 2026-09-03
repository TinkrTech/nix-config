{ config, pkgs, ... }:
{
	imports = [
		../../modules/services/users.nix
		../../modules/sops.nix
	];

	services.openssh.settings.AllowUsers = [ "admin" "vanasa" ];

	sops.secrets = {
		"admin/passwordHash".neededForUsers = true
		"vanasa/passwordHash".neededForUsers = true;
	};

	# High-privilege user for system admin
	users.users.admin = {
		isNormalUser = true;
		description = "Admin";
		uid = 950; # keep same uid as truenas_admin
		gid = 950; # keep same gid as truenas_admin
		extraGroups = [ "docker" "networkmanager" "wheel" ];
		packages = with pkgs; [
		];

		openssh.authorizedKeys = [
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH+G3FP97UOUc2SpMHtXOX0+8RwVsT99OntbS7gdzMBv jade@Ryzen-Desktop" # Mint-Desktop
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGk8iiJUsUpaxWnJc0PRIneTrt0Oz8fHgR2+5wDuwURf jade@lopen"
		];

		hashedPassword = config.sops.secrets."admin/passwordHash".path;
	};

	# Low-privilege user for shares
	users.users.vanasa = {
		isNormalUser = true;
		description = "vanasa";
		uid = 3000; # keep same uid as vanasa on truenas
		gid = 3000; # keep same gid as vanasa on truenas
		extraGroups = [ "shared" ];
		openssh.authorizedKeys = [
			# Mint-Desktop
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFtiSdfFJ3zCLbrnsaMt81YSH9cKWEpPxm+pSSDn9eOY jade@lopen"
		];
		hashedPassword = config.sops.secrets."vanasa/passwordHash".path;
	};
}
