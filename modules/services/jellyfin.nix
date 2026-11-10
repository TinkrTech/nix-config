{ config, lib, pkgs, ... }:
let
	cfg = config.hosted-services;
	url = "${cfg.jellyfin.subdomain}.${cfg.domain}";
in
{
	options.hosted-services.jellyfin = (import ./_options.nix { inherit lib; }) // {
		enable = lib.mkEnableOption "jellyfin";
		cache-dir = lib.mkOption {
			type = lib.types.path;
			default = "/var/cache/jellyfin";
		};
		config-dir = lib.mkOption {
			type = lib.types.path;
			default = "${cfg.jellyfin.data-dir}/config";
		};
		data-dir = lib.mkOption {
			type = lib.types.path;
			default = "/var/lib/jellyfin";
		};
		media-dir = lib.mkOption {
			type = lib.types.path;
		};
	};

	config = lib.mkIf cfg.jellyfin.enable {
		containers.jellyfin = {
			autoStart = true;
			privateNetwork = true;
			hostAddress = cfg.ip;
			localAddress = "10.4.0.1";

			forwardPorts = [{
				containerPort = 8096;
				hostPort = cfg.jellyfin.port;
			}];

			bindMounts = {
				"/media" = {
					hostPath = cfg.jellyfin.media-dir;
					isReadOnly = true;
				};
				"/cache" = {
					hostPath = cfg.jellyfin.cache-dir;
					isReadOnly = false;
				};
				"/config/config" = {
					hostPath = cfg.jellyfin.config-dir;
					isReadOnly = false;
				};
				"/config" = {
					hostPath = cfg.jellyfin.data-dir;
					isReadOnly = false;
				};
			};
			config = {
				system.stateVersion = config.system.stateVersion;
				environment.systemPackages = with pkgs; [
					jellyfin
					jellyfin-web
					jellyfin-ffmpeg
				];
				
				users.users.apps = config.users.users.apps;
				users.groups.apps = config.users.groups.apps;

				services.jellyfin = {
					enable = true;
					openFirewall = true;
					user = "apps";
					group = "apps";
					cacheDir = "/cache";
					configDir = "/config/config";
					dataDir = "/config";
				};	
			};
		};
		
		networking.firewall.allowedTCPPorts = [ cfg.jellyfin.port ];
		services.caddy.virtualHosts."${url}".extraConfig = ''
			reverse_proxy ${cfg.ip}:${toString cfg.jellyfin.port}
		'';
	};
}
