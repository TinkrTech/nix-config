{ config, pkgs, inputs, ... }:
{
	imports = [
		inputs.sops.nixosModules.sops
	];

	environment.systemPackages = with pkgs; [
		sops
	];
	
	sops = {
		defaultSopsFile = ../secrets/secrets.yaml;
		defaultSopsFormat = "yaml";
		age.keyFile = "/home/jade/.config/sops/age/keys-private-only.txt";
		
		secrets = {

		};
	};
}
