{ config, lib, pkgs, ... }:
let
	cfg = config.hosted-services;
in
{
	users.users."${cfg.service-user}" = {
		isNormalUser = true;
		uid = 568;
		gid = 568;
		extraGroups = [ cfg.service-group "shared" ];
		linger = true; # Keep user services running even if user is logged out
		autoSubUidGidRange = true;
	};

	users.groups."${cfg.service-group}" = { 
		gid = 568; 
	};
	users.groups.shared = { };
}
