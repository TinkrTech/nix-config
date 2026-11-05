{ config, lib, pkgs, ... }:
let
	cfg = config.hosted-services;
in
{
	options.hosted-services.caddy = {
		config-dir = lib.mkOption {
			default = "/var/lib/caddy";
			type = lib.types.path;
		};
	};

	config = {
		sops.secrets.njalla_api_token = { owner="caddy"; group="caddy"; };
		systemd.services.caddy.serviceConfig.EnvironmentFile = [ config.sops.secrets.njalla_api_token.path ];
		networking.firewall.allowedTCPPorts = [ 80 443 ];
		
		services.caddy = {
			enable = true;
			
			package = pkgs.caddy.withPlugins {
				plugins = [
					"github.com/caddy-dns/njalla@v1.0.0"
				];
				hash = "sha256-NsCpP9bl0dVt10RQoSQgQB4ZU2IgDe+988ImIx0Fw7g=";
			};

			dataDir = cfg.caddy.config-dir;
			globalConfig = ''
			acme_dns njalla {
				api_token {env.NJALLA_API_TOKEN}
			}
			'';

			virtualHosts."tinkrtech.net".extraConfig = ''
				respond "Welcome! This means Caddy and Pi-Hole are working. Is the service you want up?"
			'';
		};
	};
}
