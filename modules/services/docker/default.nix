{ config, lib, pkgs, ... }:
{
	options.hosted-services.docker = {
		enable = lib.mkEnableOption "docker";
	};
	imports = [
		./rootless.nix
		./dockge.nix
	];
}
