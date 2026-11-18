{ config, lib, pkgs, ... }:
let
	cfg = config.hosted-services;
	url = "${cfg.immich.subdomain}.${cfg.domain}";
in
{
	options.hosted-services.immich = (import ./_options.nix { inherit lib; }) // {
		enable = lib.mkEnableOption "immich";
		media-dir = lib.mkOption {
			type = lib.types.path;
		};
		hardware-acceleration.enable = lib.mkEnableOption "hardare-acceleration";
	};

	config = lib.mkIf cfg.immich.enable {
		containers.immich = {
			autoStart = true;

			privateNetwork = true;
			hostAddress = cfg.ip;
			localAddress = "10.4.0.2";
			forwardPorts = [{
				containerPort = cfg.immich.port;
				hostPort = cfg.immich.port;
			}];
			
			bindMounts = {
				"/var/lib/immich" = {
					hostPath = cfg.immich.media-dir;
					isReadOnly = false;
				};
			};

			config = {
				system.stateVersion = config.system.stateVersion;
				
				users.users.immich.uid = config.users.users.apps.uid;
				users.groups.immich.gid = config.users.groups.apps.gid;

				services.immich = {
					enable = true;
					package = pkgs.unstable.immich;
					openFirewall = true;
					host = "10.4.0.2";
					port = cfg.immich.port;
					
					# To Do: Import settings
					# See https://immich.app/docs/install/config-file for a list of options
					settings = null;

					# accelerationDevices = [ null ];
				};
				services.redis.servers.immich.logLevel = "warning";
				
				# hardware.graphics = {
				# # See https://wiki.nixos.org/wiki/Accelerated_Video_Playback
				# };
			};
		};
		
		# users.users.apps.extraGroups = [ "video" "render" ];
		networking.firewall.allowedTCPPorts = [ cfg.immich.port ];
		services.caddy.virtualHosts."${url}".extraConfig = ''
			reverse_proxy ${cfg.ip}:${toString cfg.immich.port}
		'';
	};
}
