{ lib, ... }:
{	
	subdomain = lib.mkOption {
		type = lib.types.nullOr lib.types.str;
		description = "The subdomain to access the service from";
	};
	port = lib.mkOption {
		type = lib.types.port;
		description = "The port to bind the service to";
	};
}
