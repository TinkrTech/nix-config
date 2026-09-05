{ config, pkgs, lib, ... }:
let
	inherit (lib) types;
in
{
	imports = [
		./caddy.nix
		./docker
		./immich
		./jellyfin.nix
		./pihole.nix
		./users.nix
		./vaultwarden.nix
		./wireguard.nix
	];

	options.hosted-services	= {
		service-user = lib.mkOption {
			default = "apps";
			type = lib.types.str;
		};
		service-group = lib.mkOption {
			default = "apps";
			type = lib.types.str;
		};
		ip = lib.mkOption {
			default = "127.0.0.1";
			type = lib.types.str;
			description = "The IPv4 address for the machine."
		};
		domain = lib.mkOption {
			default = "tinkrtech.net";
			type = lib.types.str;
			description = "The base domain for the services."
		};
	};

}
