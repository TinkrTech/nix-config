{ config, pkgs, ... }:
{
	service-user = "apps";
	service-group = "apps";

	users.users."${config.service-user}" = {
		isNormalUser = true;
		extraGroups = [ config.service-group "shared" ];
		linger = true; # Keep user services running even if user is logged out
		autoSubUidGidRange = true;
	};

	users.groups."${config.service-group}" = { };
	users.groups.shared = { };
}
