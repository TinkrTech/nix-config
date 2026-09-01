{ config, lib, pkgs, ... }:
let
	port = 37073;
	interface = "wg0"
	ipv4-prefix = "10.8.0";
	ipv6-prefix = "fdcc:ad94:bacf:61a4::cafe";
	peerIpsFor = subaddress: [
		"${ipv4-prefix}.${toString subaddress}/32" 
		"${ipv6-prefix}:${toString subaddress}/128"
	];

	_firewallRules = mode: isv6:
	let
		ipaddr = if isv6 then "${ipv6-prefix}:0/112" else "${ipv4-prefix}.0/24";
		iptables = if isv6 then "${pkgs.iptables}/bin/ip6tables" else "${pkgs.iptables}/bin/iptables";
	in
	''
		${iptables} -t nat ${mode} POSTROUTING -s ${ipaddr} -o eth0 -j MASQUERADE 
		${iptables} ${mode} INPUT -p udp -m udp --dport ${toString port} -j ACCEPT 
		${iptables} ${mode} FORWARD -i ${interface} -j ACCEPT
		${iptables} ${mode} FORWARD -o ${interface} -j ACCEPT 
	'';

	firewallRules = mode: lib.strings.join "\n" [ "${_firewallRules mode false}" "${_firewallRules mode true}";
in
{
	sops.secrets = {
		"wg/private-key" = {};
		"wg/jade-pixel-8-preshared" = {};
		"wg/ari-s24-preshared" = {};
		"wg/lopen-preshared" = {};
	};

	networking.wg-quick.interfaces = {
		"${interface}" = {
			address = [
				"${ipv4-prefix}.1/24"
				"${ipv6-prefix}:1/112"
			];
			privateKeyFile = sops.secrets."wg/private-key".path;
			listenPort = port;
			mtu = 1420;
			table = "main";

			# Enable Peer to route traffic to the internet
			postUp = firewallRules "-A";
			# Undo the above
			postDown = firewallRules "-D";

			peers = [
				{ # jade-pixel-8	
					publicKey = "FNu2f4hbGz/X2V3zlcAVQBqYNjjKcw2Y00xjV4NLgAA=";
					presharedKeyFile = sops.secrets."wg/jade-pixel-8-preshared".path;
					allowedIPs = peerIpsFor 3;
				}
				{ # lopen 
					publicKey = "2ZTuNT1Tc2A6/SM8yE05fSm8lVmqWI9H8uCjOlK3Hzo=";
					presharedKeyFile = sops.secrets."wg/lopen-preshared".path;
					allowedIPs = peerIpsFor 4;
				}
				{ # ari-s24
					publicKey = "JikOE8igB22pjGByfOpLssWOP74WGeudB228SXyY9Uk=";
					presharedKeyFile = sops.secrets."wg/ari-s24-preshared".path;
					allowedIPs = peerIpsFor 5;
				}
			];
		};
	};
}
