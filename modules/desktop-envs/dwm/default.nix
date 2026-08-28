{ config, pkgs, inputs, ... }:
{
	imports = [
		./dwmblocks-async.nix 
	];
	
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
			postPatch = "cp ${./dwm.h} config.def.h";
		});
		extraSessionCommands = "dwmblocks &";
	};
	
	programs.dwmblocks-async = {
		enable = true;
		blocks = [
			{
				script = ./blocks/volume.sh;
				interval_s = 0;
				signal = 10;
			}
			{
				script = ./blocks/battery.sh;
				interval_s = 5;
				signal = 11;
			}
			{
				script = ./blocks/sleep-mode.sh;
				interval_s = 0;
				signal = 12;
			}
			{
				script = ./blocks/wifi.sh;
				interval_s = 1;
				signal = 13;
			}
			{
				command = "date +'%d %b @ %H:%M'";
				interval_s = 1;
				signal = 14;
			}
		];
	};

	environment.systemPackages = with pkgs; [
		betterlockscreen # Simple lock screen
		dmenu
		dunst # libnotify daemon
		libnotify
		kitty # terminal emulator
		qutebrowser # Keyboard-based web browser
	];
	
	security.pam.services.i3lock.enable = true;

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
}
