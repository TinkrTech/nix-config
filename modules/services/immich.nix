{ config, pkgs, ... }:
let
	url = "photos.tinkrtech.net";
	ip = "10.0.0.99";
	port = 8098;
in
{
	services.immich = {
		enable = true;
		user = config.service-user;
		group = config.service-group;
		host = ip;
		port = port;
		mediaLocation = /mnt/vdev1/Photos;
	};

	services.caddy.virtualHosts."${url}".extraConfig = ''
		reverse_proxy ${ip}:${toString port}
	'';
}
