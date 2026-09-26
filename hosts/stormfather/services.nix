{ config, pkgs, ... }:
{
	imports = [
		../../modules/services
	];

	hosted-services = {
		domain = "tinkrtech.net";
		immich = {
			enable = false;
			subdomain = "photos";
			port = 8098;
			media-dir = "/mnt/vdev1/Photos";
		};

		jellyfin = {
			enable = false;
			subdomain = "jellyfin";
			port = 8096;
			cache-dir = "/mnt/vdev1/configs/jellyfin/cache";
			config-dir = "/mnt/vdev1/configs/jellyfin/config"; 
		};

		pihole.enable = false;
		
		vaultwarden = {
			enable = false;
			subdomain = "vault";
			port = 8104;
		};
		
		wireguard = {
			enable = true;
			port = 37073;
		};
	};
}
