{ config, pkgs, ... }:
let
	cfg = config.hosted-services;
	url = "${cfg.immich.subdomain}.${cfg.domain}";
in
{
	options.hosted-services.immich = (import ./_options.nix) // {
		enable = lib.mkEnableOption "immich";
		media-dir = lib.mkOption = {
			type = lib.types.path;
		};
	};

	config = lib.mkIf cfg.immich.enable {
		services.immich = {
			enable = true;
			user = cfg.service-user;
			group = cfg.service-group;
			host = cfg.ip;
			port = cfg.immich.port;
			mediaLocation = cfg.immich.media-dir;
		};
	
		services.caddy.virtualHosts."${url}".extraConfig = ''
			reverse_proxy ${cfg.ip}:${toString cfg.immich.port}
		'';
	};
}
