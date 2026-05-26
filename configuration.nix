{ config, pkgs, inputs, ... }:
{
	imports = [ 
		./hardware-configuration.nix
		./configs/nixvim.nix
		./configs/network.nix
		inputs.sops.nixosModules.sops
		inputs.flatpak.nixosModules.nix-flatpak
	];

	nix.settings.experimental-features = [ "nix-command" "flakes" ];
	boot = {
		loader.systemd-boot.enable = true;
		loader.efi.canTouchEfiVariables = true;
		kernelPackages = pkgs.linuxPackages_latest;
		supportedFilesystems = [ "nfs" ];
	};

	fileSystems."/mnt/vanasa" = {
		fsType = "nfs";
		device = "10.0.0.99:/mnt/vdev1/Shared";
		options = [ "x-systemd.automount" "noauto" ];
	};

	fileSystems."/mnt/jellyfin" = {
		fsType = "nfs";
		device = "10.0.0.99:/mnt/vdev1/Media";
		options = [ "x-systemd.automount" "noauto" ];
	};	

	systemd.tpm2.enable = false;
	
	# Set your time zone.
	time.timeZone = "America/Toronto";

	# Select internationalisation properties.
	i18n.defaultLocale = "en_CA.UTF-8";

	# Configure keymap in X11
	services.xserver.xkb = {
		layout = "us";
		variant = "";
	};
	
	services.xserver.enable = true;
	services.xserver.windowManager.dwm = {
		enable = true;
		package = pkgs.dwm.overrideAttrs(oldAttrs: {
			src = pkgs.fetchFromGitHub {
				owner = "BreadOnPenguins";
				repo = "dwm";
				rev = "4632e24484e444e7985d4675393d71d9509e066b";
				hash = "sha256-gR14bC9gcRKBFStW/YxyVtGAEiegx54I/VDIOtRfzfM=";
			};
			buildInputs = with pkgs; (oldAttrs.buildInputs or []) ++ [
				libxcb
			];
			postPatch = "cp ${./configs/dwm.h} config.def.h";
		});
		extraSessionCommands = "dwmblocks &";
	};

	systemd.services.lock-on-sleep = {
		description = "Lock the screen before sleeping";
		after = [ "sleep.target" ];
		wantedBy = [ "sleep.target" ];

		serviceConfig = {
			Type = "oneshot";
			User = "jade";
			Environment = "DISPLAY=:0 XAUTHORITY=/home/jade/.Xauthority";
			ExecStart = ''${pkgs.betterlockscreen}/bin/betterlockscreen -l'';
		};
	};
	
	services.logind.settings.Login = {
		HandleLidSwitch = "suspend";
		HandleLidSwitchExternalPower = "suspend";
		HandleLidSwitchDocked = "ignore";
	};
	
	# Audio config
	services.pulseaudio.enable = false;
	security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
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

	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

	fonts.packages = with pkgs; [
		noto-fonts
		nerd-fonts.droid-sans-mono
	];

	console.font = "Lat2-Terminus16";
	
	# List packages installed in system profile. To search, run:
	# $ nix search wget
	environment.systemPackages = with pkgs; [
		kitty
		dmenu
		qutebrowser
		bat-extras.batman
		bat-extras.batdiff
		bat-extras.prettybat
		fastfetch
		(callPackage ./srcs/dwmblocks-async.drv {
			config = ./configs/dwmblocks.h;
		})
		nfs-utils
		pinentry-curses
		sops
		htop
		pamixer
		libnotify
		dunst
		betterlockscreen
		jq
		ripgrep
	];
	security.pam.services.i3lock.enable = true;

	sops = {
		defaultSopsFile = ./secrets/secrets.yaml;
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
