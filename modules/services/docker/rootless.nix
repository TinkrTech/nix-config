{ config, lib, ...}:
let
	cfg = config.hosted-services;
in
{
	config = lib.mkIf cfg.docker.enable {
		virtualisation.docker = {
			enable = true;
			rootless = {
				enable = true;
				setSocketVariable = true;
			};
		};
		
		users.users.docker = {
			isNormalUser = true;
			group = "docker" ;
			autoSubUidGidRange = true;
			
			# Keep user services running even if user is logged out	
			linger = true; 
		};	
		
		# Enable the systemd service for docker for this user on boot
		virtualisation.oci-containers.backend = "docker";
	};
}
