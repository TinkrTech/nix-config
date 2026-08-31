{ config, pkgs, ... }:
{
	environment.systemPackages = with pkgs; [
		bat
		bat-extras.batdiff
		bat-extras.batman
		bat-extras.prettybat
		fastfetch
		git
		htop
		jq
		pinentry-curses
		ripgrep
		xclip
		tree
	];
	
	# GPG
	programs.gnupg.agent = {
		enable = true;
		pinentryPackage = pkgs.pinentry-curses;
		enableSSHSupport = true;
	};

	# Enable CUPS to print documents.
	services.printing.enable = true;
}
