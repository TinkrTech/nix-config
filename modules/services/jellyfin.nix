{ config, lib, pkgs, ... }:
let
	cfg = config.hosted-services;
	url = "${cfg.jellyfin.subdomain}.${cfg.domain}";
in
{
	options.hosted-services.jellyfin = (import ./_options.nix { inherit lib; }) // {
		enable = lib.mkEnableOption "jellyfin";
		cache-dir = lib.mkOption {
			type = lib.types.path;
		};
		config-dir = lib.mkOption {
			type = lib.types.path;
		};
		data-dir = lib.mkOption {
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
			user = "apps";
			group = "apps";
			cacheDir = cfg.jellyfin.cache-dir;
			configDir = cfg.jellyfin.config-dir;
			dataDir = cfg.jellyfin.data-dir;
		};

		services.caddy.virtualHosts."${url}".extraConfig = ''
			reverse_proxy ${cfg.ip}:${toString cfg.jellyfin.port}
		'';
	};
}
