{ config, pkgs, ... }:
{
	imports = [
		../../modules/services
	];

	hosted-services = {
		domain = "tinkrtech.net";
		ip = "10.0.0.99";
		immich = {
			enable = true;
			subdomain = "photos";
			port = 8098;
			media-dir = "/mnt/vdev1/Photos";
		};

		jellyfin = {
			enable = true;
			subdomain = "jellyfin";
			port = 8096;
			media-dir = "/mnt/vdev1/Media";
			cache-dir = "/mnt/vdev1/configs/jellyfin/cache";
			config-dir = "/mnt/vdev1/configs/jellyfin/config/config"; 
			data-dir = "/mnt/vdev1/configs/jellyfin/config";
		};

		pihole.enable = true;
	
		uptime-kuma = {
			enable = true;
			subdomain = "status";
			port = 8106;
			data-dir = "/mnt/vdev1/configs/UptimeKuma";
		};

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
