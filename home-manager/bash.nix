{ config, pkgs, inputs, hostName, ... }:
let
	aliases = {
		# bat aliases
		cat = "bat -p";
		lsbc = "lsblk | bat -l=conf -p";
		man = "batman";
		
		# screenfetch lmao
		screenfetch = "fastfetch";

		# NixOS Aliases
		rebuild = "sudo nixos-rebuild switch --flake ~/nixos#${hostName}";
		test-cfg = "sudo nixos-rebuild test --flake ~/nixos#${hostName}";
		cleanup = "sudo nix-collect-garbage -d";
		list-gen = "nixos-rebuild list-generations";
		## Home-Manager Aliases
		# hm-rebuild = "home-manager switch --flake ~/nixos#${hostName}";
		# hm-list-gen = "home-manager generations";
		# Flake Aliases
		update = "nix flake update --flake ~/nixos; rebuild";
	};
in
{
	programs.bash = {
		enable = true;
		shellAliases = aliases;
		historyControl = ["erasedups" "ignoreboth"];
	};
}
