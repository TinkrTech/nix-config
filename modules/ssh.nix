{ config, lib, pkgs, ... }:
{
	# Note: services.openssh.users and 
	# users.users."myUser".authorizedKeys.keys must be set in configuration.nix
	services.openssh = {
		enable = true;
		openFirewall = true;
		settings = {
			PasswordAuthentication = false;
			KbdInteractiveAuthentication = false;
			PermitRootLogin = "no";
		};
	};
}
