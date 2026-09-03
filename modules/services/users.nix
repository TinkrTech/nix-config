{ config, pkgs, ... }:
{
	service-user = "apps";
	service-group = "apps";

	users.users."${config.service-user}" = {
		isNormalUser = true;
		uid = 568;
		gid = 568;
		extraGroups = [ config.service-group "shared" ];
		linger = true; # Keep user services running even if user is logged out
		autoSubUidGidRange = true;
	};

	users.groups."${config.service-group}" = { 
		gid = 568; 
	};
	users.groups.shared = { };
}
