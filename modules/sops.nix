{ config, pkgs, inputs, ... }:
{
	imports = [
		inputs.sops.nixosModules.sops
	];
	
	environment.systemPackages = with pkgs; [
		sops
	];
	
	sops = {
		defaultSopsFile = ../secrets.yaml;
		defaultSopsFormat = "yaml";
	};	
}
