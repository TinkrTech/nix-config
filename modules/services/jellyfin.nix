{ config, pkgs, ... }:
let
	cfg = config.hosted-services;
	url = "${cfg.jellyfin.subdomain}.${cfg.domain}";
in
{
	options.hosted-services.jellyfin = (import ./_options.nix) // {
		enable = lib.mkEnableOption "jellyfin";
		cache-dir = lib.mkOption {
			type = lib.types.path;
		};
		config-dir = lib.mkOption {
			type = lib.types.path;
		};
	};

	config = lib.mkIf cfg.jellyfin.enable {
		environment.systemPackages = with pkgs; [
			jellyfin
			jellyfin-web
			jellyfin-ffmpeg
		];

		services.jellyfin = {
			enable = true;
			openFirewall = true;
			# TODO: Figure out port overrides
			user = cfg.service-user;
			group = cfg.service-group;
			cacheDir = cfg.jellyfin.cache-dir;
			configDir = cfg.jellyfin.config-dir;
		};

		services.caddy.virtualHosts."${url}".extraConfig = ''
			reverse_proxy ${cfg.ip}:${toString cfg.jellyfin.port}
		'';
	};
}
