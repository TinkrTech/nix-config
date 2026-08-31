{ config, lib, pkgs, ...}:
{
	virtualisation.docker = {
		enable = true;
		rootless = {
			enable = true;
			setSocketVariable = true;
		};
	};
	
	users.users.docker = {
		isNormalUser = true;
		extraGroups = [ "docker" ];
		linger = true; # Keep user services running even if user is logged out
		autoSubUidGidRange = true;
	};
	
	# Enable the systemd service for docker for this user on boot
	virtualisation.oci-containers.backend = "docker";

}
