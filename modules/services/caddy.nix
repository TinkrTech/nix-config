{ config, lib, pkgs, ... }:
let
	cfg = config.hosted-services;
in
{
	options.hosted-services.caddy = {
		config-dir = lib.mkOption {
			default = "/var/lib/caddy";
			type = lib.types.path;
		};
	};

	config = {
		services.caddy = {
			enable = true;
			dataDir = cfg.caddy.config-dir;
		};
	};
}
