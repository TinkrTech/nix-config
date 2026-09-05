{ config, pkgs, ... }:
let
	cfg = config.hosted-services;
in
{
	options.hosted-services.pihole = {
		enable = lib.mkEnableOption "pihole";
	};

	config = lib.mkIf cfg.pihole.enable {
		services.pihole-ftl = {
			enable = true;
			user = config.service-user;
			dns.upstreams = [
				"9.9.9.9" # Quad9
				"1.1.1.1" # cloudflare
			];
	
			# local DNS resolving
			dns.hosts = [ "${cfg.ip} ${cfg.domain}" ];
			openFirewallDNS = true;
			openFirewallDHCP = true;
		};
	};
}
