{ config, pkgs, inputs, ... }:
{
	programs.git = {
		enable = true;
		settings = {
			user = {
				name = "Jade T";
				email = "jade@tinkrtech.net";
			};
			init.defaultBranch = "main";
			core.sshCommand = "ssh -i ~/.ssh/github";
			alias = {
				lg = "log --oneline";
				lgbt = "lg --graph main..HEAD";
				fixup = "commit --fixup HEAD";
			};
		};
	};
}
