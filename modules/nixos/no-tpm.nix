{ config, pkgs, inputs, ... }:
{
	security.tpm2.enable = false;
	boot.initrd.systemd.units = {
		"dev-tpm0.device".enable = false;
		"dev-tpmrm0.device".enable = false;
	};
	systemd.units = {
		"dev-tpm0.device".enable = false;	
		"dev-tpmrm0.device".enable = false;
	};	
}
