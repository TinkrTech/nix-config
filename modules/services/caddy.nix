{ config, pkgs, ... }:
{
	services.caddy = {
		enable = true;
		user = config.service-user;
	};
}
