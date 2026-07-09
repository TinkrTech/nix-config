{ config, pkgs, inputs, ... }:
{
	nixpkgs.config.allowUnfree = true;

	time.timeZone = "America/Toronto";

	i18n.defaultLocale = "en_CA.UTF-8";

	services.xserver.xkb = {
		layout = "us";
		variant = "";
	};
	
	console.font = "Lat2-Terminus16";
	fonts.packages = with pkgs; [
		noto-fonts
		nerd-fonts.droid-sans-mono
	];

}
