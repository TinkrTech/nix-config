{ config, pkgs, lib, ... }:
let
	inherit (lib) types;
	filterDir = filter: dir: lib.filterAttrs filter (builtins.readDir dir);
	listModules = dir: map (s: dir + "/${s}") (
		builtins.attrNames(
			filterDir(name: _: name != "default.nix" && !lib.hasPrefix "_" name) dir
		)
	);
in
{
	imports = listModules ./.;
	
	options.hosted-services	= {
		ip = lib.mkOption {
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
