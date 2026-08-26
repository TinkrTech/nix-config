{ config, pkgs, inputs, ...}:
{
	imports = [
		inputs.flatpak.nixosModules.nix-flatpak
	];

	xdg.portal = {
		enable = true;
		config = {
			common = {
				default = [ "gtk" ];
			};
		};
		extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
	};

	services.flatpak = {
		enable = true;
	}
}
