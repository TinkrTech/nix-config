{ config, lib, pkgs, ...}:
let
	cfg = config.hosted-services;
in
{
	virtualisation.docker = {
		enable = true;
		rootless = {
			enable = true;
			setSocketVariable = true;
		};
	};
	
	users.users."${cfg.service-user}" = {
		extraGroups = [ "docker" ];
	};
	
	# Enable the systemd service for docker for this user on boot
	virtualisation.oci-containers.backend = "docker";

}
