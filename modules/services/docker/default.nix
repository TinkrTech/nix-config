{ config, lib, pkgs, ... }:
{
	options.hosted-services.docker = {
		enable = lib.mkEnableOption "docker";
	};
	config = lib.mkIf config.hosted-services.docker.enable {
		imports = [
			./rootless.nix
			./dockge.nix
		];
	};
}
