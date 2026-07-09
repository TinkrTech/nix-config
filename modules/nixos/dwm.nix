{ config, pkgs, inputs, ... }:
{
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
			postPatch = "cp ${./dwm/dwm.h} config.def.h";
		});
		extraSessionCommands = "dwmblocks &";
	};
	
	environment.systemPackages = with pkgs; [
		(callPackage ./dwm/dwmblocks-async.drv {
			config = ./dwm/dwmblocks.h;
		})
		betterlockscreen
		dmenu
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
