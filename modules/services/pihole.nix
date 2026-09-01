{ config, pkgs, ... }:
{
	services.pihole-ftl = {
		enable = true;
		user = config.service-user;
		dns.upstreams = [
			"9.9.9.9" # Quad9
			"1.1.1.1" # cloudflare
		];

		# local DNS resolving
		dns.hosts = [ "10.0.0.99 tinkrtech.net" ];
		openFirewallDNS = true;
		openFirewallDHCP = true;
	};
}
