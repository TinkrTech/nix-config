{ config, pkgs, inputs, ...}:
{
	imports = [ inputs.nixvim.nixosModules.nixvim ];
	programs.nixvim = {
		enable = true;
		defaultEditor = true;
	 	opts = {
			number = true;
			relativenumber = true;
			tabstop = 4;
			shiftwidth = 4;
		};
		globals.mapleader = " ";
		keymaps = [
			{
				mode = "n";
				key = "<leader>w";
				action = ":w<CR>";
			}
		];
		colorschemes.catppuccin.enable = true;
	
		plugins = {
			which-key.enable = true;
			telescope.enable = true;
			oil.enable = true;
			treesitter.enable = true;
			web-devicons.enable = true;
		};

		plugins.lsp = {
			enable = true;
			servers = { 
				pylsp.enable = true;
			};
		};

		plugins.cmp = {
			enable = true;
			autoEnableSources = true;
		};

		filetype.extension = {
			drv = "nix";
		};
	};
}
