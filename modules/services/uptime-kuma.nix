{ config, pkgs, lib, ... }:
let
	cfg = config.hosted-services;
	url = "${cfg.uptime-kuma.subdomain}.${cfg.domain}";
in
{
	options.hosted-services.uptime-kuma = (import ./_options.nix { inherit lib; }) // {
		enable = lib.mkEnableOption "uptime-kuma";
		data-dir = lib.mkOption {
			type = lib.types.path;
		};
	};

	config = lib.mkIf cfg.uptime-kuma.enable {
		services.uptime-kuma = {
			enable = true;

			settings = {
				HOST = cfg.ip;
				PORT = toString cfg.uptime-kuma.port;
			};
		};
		
		services.caddy.virtualHosts."${url}".extraConfig = ''
			reverse_proxy ${cfg.ip}:${toString cfg.uptime-kuma.port}
		'';
	};
}
