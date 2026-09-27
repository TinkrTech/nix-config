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
			rebase.autosquash = true;

			alias = {
				alias = "config --get-regexp ^alias";
				contributors = "shortlog -sne --all";
				drag = "blame -wCCC";
				fixup = "commit --fixup HEAD";
				lg = "log --oneline";
				lgbt = "lg --graph main..HEAD";
				cdiff = ''!f() { git diff "$1~1"..$1 --compact-summary; }; f'';
				wdiff = ''!f() { git diff "$1~1"..$1 --word-diff; }; f'';
				rebase-branch = ''!f() { git rebase -i $(git merge-base main HEAD); }; f'';
				rename = ''!rename() {
					git branch --unset-upstream && git push origin -d "$1";
					git branch -m "$1" "$2" && git push origin -u "$2";
				}; rename'';
			};

			push.autoSetupRemote = true;
		};
	};
}
