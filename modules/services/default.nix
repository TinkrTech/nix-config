{ config, pkgs, lib, ... }:
let
	inherit (lib) types;
in
{
	imports = [
		./caddy.nix
		./docker
		./immich.nix
		./jellyfin.nix
		./pihole.nix
		./vaultwarden.nix
		./wireguard.nix
	];
	
	options.hosted-services	= {
		ip = lib.mkOption {
			default = "127.0.0.1";
			type = lib.types.str;
			description = "The IPv4 address for the machine.";
		};
		domain = lib.mkOption {
			default = "tinkrtech.net";
			type = lib.types.str;
			description = "The base domain for the services.";
		};
	};

}
