#Edit this configuration file to define what should be installed on
# your system.	Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
	imports = [ # Include the results of the hardware scan.
		./hardware-configuration.nix
		inputs.nixvim.nixosModules.nixvim
		inputs.sops.nixosModules.sops
	];
	
#	nixpkgs.overlays = [
#		(final: prev: {
#			dwm = prev.dwm.overrideAttrs
#		})
#	];

	nix.settings.experimental-features = [ "nix-command" "flakes" ];
	boot = {
		loader.systemd-boot.enable = true;
		loader.efi.canTouchEfiVariables = true;
		kernelPackages = pkgs.linuxPackages_latest;
	};
	systemd.tpm2.enable = false;

	networking = {
		hostName = "nixos-laptop";
		networkmanager = {
			enable = true;
			plugins = [ pkgs.networkmanager-openvpn ];
		};
		firewall = {
			logReversePathDrops = true; # Show dropped packets in dmesg 
			# Ignore Wireguard traffic (rpfilter gets confused)
			extraCommands = ''
				ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN
			'';
			extraStopCommands = ''
				ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN || true
				ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN || true
			'';
		};
		
	};

	services.openvpn.servers = {
		pia = {
			autoStart = false;
			authUserPass = {
				username = config.sops.secrets."pia/username".path;
				password = config.sops.secrets."pia/password".path;
			};
			
			config = ''
				client
				dev tun
				proto udp
				remote ca-ontario-so.privacy.network 1197
				resolv-retry infinite
				nobind
				persist-key
				persist-tun
				cipher aes-256-cbc
				auth sha256
				tls-client
				remote-cert-tls server

				auth-user-pass
				compress
				verb 1
				reneg-sec 0

				crl-verify ${config.sops.secrets."pia/ontario-so-crl".path}
				ca ${config.sops.secrets."pia/ontario-so-ca".path}

				disable-occ
			'';
		};
	};
	
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
#		package = pkgs.dwm.overrideAttrs {
#			src = ./srcs/dwm;	
#		};

		package = pkgs.dwm.overrideAttrs {
			src = pkgs.fetchFromGitHub {
				owner = "BreadOnPenguins";
				repo = "dwm";
				rev = "4632e24484e444e7985d4675393d71d9509e066b";
				hash = "sha256-gR14bC9gcRKBFStW/YxyVtGAEiegx54I/VDIOtRfzfM=";
			};
			postPatch = "cp ${./configs/dwm.h} config.def.h";
		};
		extraSessionCommands = "dwmblocks &";
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
	];
	
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
	# services.pcscd.enable = true;

	programs.nixvim = {
		enable = true;
		defaultEditor = true;
	 	opts = {
			number = true;
			relativenumber = true;
			tabstop = 4;
			shiftwidth = 4;
		};
		globals.mapleader = " ";
		keymaps = [
			{
				mode = "n";
				key = "<leader>w";
				action = ":w<CR>";
			}
		];
		colorschemes.catppuccin.enable = true;
	
		plugins = {
			which-key.enable = true;
			telescope.enable = true;
			oil.enable = true;
			treesitter.enable = true;
			web-devicons.enable = true;
		};

		plugins.lsp = {
			enable = true;
			servers = { 
				pylsp.enable = true;
			};
		};

		plugins.cmp = {
			enable = true;
			autoEnableSources = true;
		};

		filetype.extension = {
			drv = "nix";
		};
	};

	programs.git.enable = true;
	programs.bat.enable = true;

	# This value determines the NixOS release from which the default
	# settings for stateful data, like file locations and database versions
	# on your system were taken. It‘s perfectly fine and recommended to leave
	# this value at the release version of the first install of this system.
	# Before changing this value read the documentation for this option
	# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "25.05"; # Did you read the comment?
}
