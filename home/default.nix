{ config, ... }:
{
	imports = [
		./bash.nix
		./git.nix
	];
	home.homeDirectory = "/home/${config.home.username}";
	
	# Let Home Manager install and manage itself.
	programs.home-manager.enable = true;
}
