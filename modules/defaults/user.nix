{ config, ... }:
{	
	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.jade = {
		isNormalUser = true;
		description = "Jade";
		extraGroups = [ "networkmanager" "wheel" ];
	};
}
