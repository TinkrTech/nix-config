{
	description = "Jade's NixOS Config";
	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";
		nixvim = {
			url = "github:nix-community/nixvim/nixos-26.05";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		homemanager = {
			url = "github:nix-community/home-manager?ref=release-26.05";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		sops = {
			url = "github:Mic92/sops-nix";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		flatpak = {
			url = "github:gmodena/nix-flatpak";
		};
	};
	
	outputs = { self, nixpkgs, home-manager, ... } @ inputs: 
	let
		lib = nixpkgs.lib;
		pkgs = nixpkgs.legacyPackages."x86_64-linux";
		hosts = [
			"lopen"
			"syl"
		];
	in
	{
		nixosConfigurations = nixpkgs.lib.genAttrs hosts (hostName: nixpkgs.lib.nixosSystem {
			specialArgs = { inherit inputs; };
			modules = [
				{ networking.hostName = hostName; }
				./hosts/${hostName}/configuration.nix
				inputs.sops.nixosModules.sops
				inputs.flatpak.nixosModules.nix-flatpak
			];
		});
		homeConfigurations = nixpkgs.lib.genAttrs hosts (hostName: home-manager.lib.homeManagerConfiguration {
			inherit pkgs;
			extraSpecialArgs = { inherit hostName; };
			modules = [
				./hosts/${hostName}/home.nix
			];
		});
	};
}
