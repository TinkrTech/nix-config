{ config, pkgs, ... }:
{
	imports = [
		../../modules/sops.nix
	];
	
	sops = {
		secrets = {
			"home-vpn/preshared" = {};
			"home-vpn/private-key" = {};
		};
	};
	
	networking.networkmanager.enable = true;
	
	environment.systemPackages = with pkgs; [
		wireguard-tools
	];

	networking.firewall = {
		enable = true;
		trustedInterfaces = [ "home-vpn" ];
		allowedUDPPorts = [ 37073 ];
	};
	
	networking.wg-quick.interfaces = {
		home-vpn = {
			address = [ "10.8.0.4/32" "fdcc:ad94:bacf:61a4::cafe:4/128" ];
			dns = [ "10.0.0.99" ];
			privateKeyFile = config.sops.secrets."home-vpn/private-key".path;
			peers = [{
				publicKey = "Cntlk+YO7ssRfjH3lmk794PMLm/rizDiKnPmNXr0IGg=";
				endpoint = "38.131.89.123:37073";
				allowedIPs = [ "10.0.0.99/32" ];
				presharedKeyFile = config.sops.secrets."home-vpn/preshared".path;
			}];
		};
	};
}

