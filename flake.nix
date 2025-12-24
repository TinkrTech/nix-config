{
	description = "Jade's NixOS Config";
	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
		nixvim.url = "github:nix-community/nixvim?ref=nixos-25.05";
		homemanager = {
			url = "github:nix-community/home-manager?ref=release-25.05";
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
	in
	{
		nixosConfigurations.nixos-laptop = nixpkgs.lib.nixosSystem {
			specialArgs = { inherit inputs; };
			modules = [
				./configuration.nix
				inputs.sops.nixosModules.sops
				inputs.flatpak.nixosModules.nix-flatpak
			];
		};
		homeConfigurations.jade = home-manager.lib.homeManagerConfiguration {
			inherit pkgs;
			modules = [
				./jade.nix
			];
		};
	};
}
