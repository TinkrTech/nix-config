{ config, pkgs, inputs, ... }:
{
	imports = [ 
		./hardware-configuration.nix
		../../modules/nixos/audio.nix
		../../modules/nixos/dwm.nix
		../../modules/nixos/locale.nix
		../../modules/nixos/nas-nfs.nix
		../../modules/nixos/network.nix
		../../modules/nixos/nixvim.nix
		../../modules/nixos/no-tpm.nix
		inputs.sops.nixosModules.sops
		inputs.flatpak.nixosModules.nix-flatpak
	];

	nix.settings.experimental-features = [ "nix-command" "flakes" ];
	boot = {
		loader.systemd-boot.enable = true;
		loader.efi.canTouchEfiVariables = true;
		kernelPackages = pkgs.linuxPackages_latest;
	};	
	
	xdg.portal = {
		enable = true;
		config = {
			common = {
				default = [ "gtk" ];
			};
		};
		extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
	};

	services.flatpak = {
		enable = false;
		packages = [
			"com.Bitwarden.desktop"	
		];
	};
	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.jade = {
		isNormalUser = true;
		description = "Jade";
		extraGroups = [ "networkmanager" "wheel" ];
		packages = with pkgs; [
			termusic
			playerctl
		];
	};
	
	# List packages installed in system profile. To search, run:
	# $ nix search wget
	environment.systemPackages = with pkgs; [
		kitty
		qutebrowser
		bat-extras.batman
		bat-extras.batdiff
		bat-extras.prettybat
		fastfetch
		pinentry-curses
		sops
		htop
		libnotify
		dunst
		jq
		ripgrep
	];

	sops = {
		defaultSopsFile = ../../secrets/secrets.yaml;
		defaultSopsFormat = "yaml";
		age.keyFile = "/home/jade/.config/sops/age/keys-private-only.txt";
		
		secrets = {
			"pia/username" = {};
			"pia/password" = {};
			"pia/ontario-so-crl" = {};
			"pia/ontario-so-ca" = {};
			"homevpn-conf" = {};
		};
	};

	programs.gnupg.agent = {
		enable = true;
		pinentryPackage = pkgs.pinentry-curses;
		enableSSHSupport = true;
	};

	programs.bat.enable = true;	
	programs.git.enable = true;

	# This value determines the NixOS release from which the default
	# settings for stateful data, like file locations and database versions
	# on your system were taken. It‘s perfectly fine and recommended to leave
	# this value at the release version of the first install of this system.
	# Before changing this value read the documentation for this option
	# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "25.05"; # Did you read the comment?
}
