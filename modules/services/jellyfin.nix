{ config, pkgs, ... }:
let
	url = "jellyfin.tinkrtech.net";
	ip = "10.0.0.99";
	port = 8096;
in
{
	environment.systemPackages = with pkgs; [
		jellyfin
		jellyfin-web
		jellyfin-ffmpeg
	];

	services.jellyfin = {
		enable = true;
		openFirewall = true;
		# TODO: Figure out port overrides
		user = config.service-user;
		group = config.service-group;
		cacheDir = "/mnt/vdev1/configs/jellyfin/cache";
		configDir = "/mnt/vdev1/configs/jellyfin/config";
	};

	services.caddy.virtualHosts."${url}".extraConfig = ''
		reverse_proxy ${ip}:${toString port}
	'';
}
