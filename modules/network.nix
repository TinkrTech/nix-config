{ config, pkgs, ... }:
{
	imports = [
		./sops.nix
	];
	
	sops = {
		secrets = {
			"pia/username" = {};
			"pia/password" = {};
			"pia/ontario-so-crl" = {};
			"pia/ontario-so-ca" = {};
			"homevpn-conf" = {};
		};
	};

	networking = {
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
}
