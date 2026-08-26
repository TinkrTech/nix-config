{ config, pkgs, inputs, ...}:
{
	imports = [ inputs.nixvim.nixosModules.nixvim ];
	programs.nixvim = {
		enable = true;
		# Suppress nixpkgs mismatch warning
		nixpkgs.pkgs = pkgs;
		defaultEditor = true;
	 	opts = {
			number = true;
			relativenumber = true;
			tabstop = 4;
			shiftwidth = 4;
			wrap = false;

			swapfile = false;
			backup = false;
			
			undofile = true;
			
			hlsearch = false;
			incsearch = true;

			termguicolors = true;

			updatetime = 50;
		};

		globals.mapleader = " ";
		keymaps = [
			{
				mode = "n";
				key = "<leader>w";
				action = ":w<CR>";
			}
			{
				mode = "n";
				key = "<leader>so";
				action = ":so<CR>";
			}
			{
				mode = "n";
				key = "<leader>e";
				action = ":Ex<CR>";
			}
			{
				mode = "n";
				key = "<leader>x";
				action = "<cmd>!chmod +x \"%\"<CR>";
				options.silent = true;
			}
			
	 		{
	 			mode = "n";
	 			key = "<leader>a";
	 			action.__raw = "function() require('harpoon'):list():add() end";
	 			options.desc = "Harpoon: Add file";
			}
			{
				mode = "n";
				key = "<C-e>";
				action.__raw = ''
					function() 
						harpoon = require('harpoon')
						harpoon.ui:toggle_quick_menu(harpoon:list())
					end
				'';
				options.desc = "Harpoon: Toggle Menu";
			}
			{
				mode = "n";
				key = "<C-j>";
	 			action.__raw = "function() require('harpoon'):list():next() end";
				options.desc = "Harpoon: Next";
			}
			{
				mode = "n";
				key = "<C-k>";
	 			action.__raw = "function() require('harpoon'):list():prev() end";
				options.desc = "Harpoon: Prev";
			}
			
			{
				mode = "n";
				key = "<leader>u";
				action = "<cmd>UndotreeToggle<CR>";
				options.desc = "Toggle Undotree";
				options.silent = true;
			}
		];
		colorschemes.catppuccin.enable = true;
	
		plugins = {
			cmp = {
				enable = true;
				autoEnableSources = true;
			};
			harpoon.enable = true;
			lsp = {
				enable = true;
				servers = { 
					pylsp.enable = true;
					lua_ls.enable = true;
					bashls.enable = true;
				};
			};
			telescope = {
				enable = true;
				extensions = {
					fzf-native.enable = true;
				};
				keymaps = {
					"<leader>ff" = {
						action = "find_files";
						options.desc = "Telescope: Find files";
					};
					"<leader>fh" = {
						action = "help_tags";
						options.desc = "Telescope: Help tags";
					};
					"<leader>fs" = {
						action = "grep_string";
						options.desc = "Telescope: Find in file";
					};
					"<C-p>" = {
						action = "git_files";
						options.desc = "Telescope: Search git files";
					};
				};
			};

			treesitter = {
				enable = true;
				settings = {
					highlight.enable = true;
				};
				nixvimInjections = true;
				grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars;
			};

			undotree.enable = true;
			web-devicons.enable = true;
			which-key.enable = true;
		};

		filetype.extension = {
			drv = "nix";
		};
	};
}
