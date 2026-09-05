{ config, pkgs, ... }:
{
	imports = [
		../../modules/services
	];

	services-module = {
		ip = "10.0.0.99";
		domain = "tinkrtech.net";

		immich = {
			enable = true;
			subdomain = "photos";
			port = 8098;
			locations = {
				media = "/mnt/vdev1/Photos";
			};
		};

		jellyfin = {
			enable = true;
			subdomain = "jellyfin";
			port = 8096;
			locations = {
				cache = "/mnt/vdev1/configs/jellyfin/cache";
				config = "/mnt/vdev1/configs/jellyfin/config"; 
			};
		};

		pihole.enable = true;
		
		vaultwarden = {
			enable = true;
			subdomain = "vault";
			port = 8104;
		};
		
		wireguard = {
			enable = true;
			port = 37073;
		};
	};

}
