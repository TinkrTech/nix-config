{
	description = "Jade's NixOS Config";
	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";
		nixvim = {
			url = "github:nix-community/nixvim/nixos-26.05";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		home-manager = {
			url = "github:nix-community/home-manager/release-26.05";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		sops = {
			url = "github:Mic92/sops-nix";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		deploy-rs = {
			url = "github:serokell/deploy-rs";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		flatpak = {
			url = "github:gmodena/nix-flatpak";
		};
	};
	
	outputs = { self, nixpkgs, home-manager, deploy-rs, ... } @ inputs: 
	let
		lib = nixpkgs.lib;
		pkgs = nixpkgs.legacyPackages."x86_64-linux";
		inherit (lib.strings) removePrefix removeSuffix hasPrefix;
	in
	let
		/* filterDir :: (String -> String -> bool) -> Path -> { Path :: String }
			filter a directory */
		filterDir = filter: dir: lib.filterAttrs filter (builtins.readDir dir);

		hosts = builtins.attrNames (
			filterDir (name: type: name != "template" && type == "directory") ./hosts
		);

		/* _extractUserFromHomeFile :: String -> String
			Take a home-file of the form `home-<user>.nix` and return `user` */
		_extractUserFromHomeFile = homeFile: removeSuffix ".nix" (removePrefix "home-" homeFile);
		
		/* _filesToFileByUser :: string -> { Path :: string } -> { string :: Path }
			Take a list of `home-<user>.nix` files and return a set of 
			{ `user` = `./hosts/host/home-<user>.nix` } */
		_filesToFileByUser = host: files:
			lib.attrsets.concatMapAttrs (file: _: {
				${_extractUserFromHomeFile file} = ./hosts/${host}/${file};
			}) files;
		
		/* hostHomesByUser :: String -> { [String] :: Path }
			Given a host name returns a set of users and the path to their home files 
			Expects users' home files to be named `home-<user>.nix`
			Note: case-sensitive */
		hostHomesByUser = host: _filesToFileByUser host (
			filterDir (name: type: 
				type == "regular" && hasPrefix "home-" name
			) ./hosts/${host}
		);
	in
	{
		nixosConfigurations = nixpkgs.lib.genAttrs hosts (hostName: nixpkgs.lib.nixosSystem {
			specialArgs = { inherit inputs; };
			system = "x86_64-linux";
			modules = [
				{ networking.hostName = hostName; }
				./hosts/${hostName}/configuration.nix
				inputs.sops.nixosModules.sops
				inputs.flatpak.nixosModules.nix-flatpak
				home-manager.nixosModules.home-manager
				{
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;
					home-manager.extraSpecialArgs = { 
						inherit inputs; 
						inherit hostName; 
					};
					home-manager.users = hostHomesByUser hostName;
				}
			];
		});

		deploy.nodes = 
		let
			activate = host: deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations."${host}";
		in
		{
			stormfather = {
				hostname = "stormfather";
				sshUser = "admin";
				user = "root";
				profiles.system.path = activate "stormfather";	
			};
			checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
		};
	};
}
