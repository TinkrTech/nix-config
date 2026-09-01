{ config, pkgs, ...}:
let
	url = "vault.tinkrtech.net";
	ip = "10.0.0.99";
	port = 8104;
in
{
	sops.secrets = {
		"vaultwarden/env-file" = {};
	};

	services.vaultwarden = {
		enable = true;
		user = config.service-user;
		group = config.service-group;
		
		package = pkgs.vaultwarden-postgresql;
		
		configurePostgres = true;
		domain = url;

		# TODO: create ADMIN_TOKEN and SMTP_PASSWORD env file
		environmentFile = sops.secrets."vaultwarden/env-file".path;

		config = {
			SIGNUPS_ALLOWED = true;

			ROCKET_ADDRESS = ip;
			ROCKET_PORT = port;
			ROCKET_LOG = "critical";

			SMTP_HOST = "smtp.protonmail.ch";
			SMTP_PORT = 587;
			SMTP_USERNAME = "hosted@tinkrtech.net";
			# SMTP_PASSWORD in environmentFile
			SMTP_TIMEOUT = 15;
			SMTP_EMBED_IMAGES = true;
			SMTP_SECURITY = "starttls";
			SMTP_FROM = "hosted@tinkrtech.net";
			SMTP_FROM_NAME = "Vaultwarden";
		};
	};

	services.caddy.virtualHosts."${url}".extraconfig = ''
		encode zstd gzip
		reverse_proxy ${ip}:${toString port} {
			header_up X-Real-IP {remote_host}
		}
	'';
}
