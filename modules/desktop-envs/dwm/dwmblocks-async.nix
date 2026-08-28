# Author: Jade T <jade@tinkrtech.net>
# Date: 2026-08-27
/*
todo:
- Make command / script / script_raw options mutually exclusive
- Test lmao
*/
{
	config,
	lib,
	pkgs,
	...
}:
let
	cfg = config.programs.dwmblocks-async;
	inherit (lib) types mkOption mkEnableOption;

	blockType = types.submodule {
		options = {
			command = mkOption {
				type = types.nullOr types.str;
				default = null;
				description = "The shell command to run for the block";
			};
			script = mkOption {
				type = types.nullOr types.path;
				default = null;
				description = "The path to the script to run for the block";
			};
			script_raw = mkOption {
				type = types.nullOr types.str;
				default = null;
				description = "The script to run for the block";
			};

			icon = mkOption {
				type = types.str;
				default = "";
				description = "The icon displayed before the block output";
			};

			interval_s = mkOption {
				type = types.int;
				description = "The update interval in seconds (0 for signal only)";
			};

			signal = mkOption {
				type = types.int;
				description = "Which realtime signal to use for updates";
			};
		};
	};

	serializeBlock = index: block:
		let
			cmd = 
				if block.script != null then 
					block.script
				else if block.command != null then
					block.command
				else if block.script_raw != null then
					pkgs.writeScript "dwmblocks-${toString index}" block.script_raw
				else
					throw "dwmblocks-async: A block must define 'script', 'script_raw', or 'command'."
				;
		in
			''X("${block.icon}", "${cmd}", ${toString block.interval_s}, ${toString block.signal})'';
	
	configFile = pkgs.writeText "config.h" ''
		#ifndef CONFIG_H
		#define CONFIG_H

		// String used to delimit block outputs in the status.
		#define DELIMITER "${cfg.delimiter.value}"

		// Maximum number of Unicode characters that a block can output.
		#define MAX_BLOCK_OUTPUT_LENGTH ${toString cfg.max_block_length}

		// Control whether blocks are clickable.
		#define CLICKABLE_BLOCKS ${if cfg.clickable_blocks then "1" else "0"}

		// Control whether a leading delimiter should be prepended to the status.
		#define LEADING_DELIMITER ${if cfg.delimiter.leading then "1" else "0"}

		// Control whether a trailing delimiter should be appended to the status.
		#define TRAILING_DELIMITER ${if cfg.delimiter.trailing then "1" else "0"}

		// Define blocks for the status feed as X(icon, cmd, interval, signal).
		#define BLOCKS(X) \
			${lib.concatStringsSep " \\\n			" (lib.imap serializeBlock cfg.blocks)}
		#endif  // CONFIG_H
	'';
	
	dwmblocks-async = pkgs.stdenv.mkDerivation {
		name = "dwmblocks-async";
		system = "x86_64-linux";
		meta = {
			description = ''
				dwmblocks-async is a status bar for dwm that allows you to define sections or "blocks" that update independently from one-another.
			'';
		};
		
		buildInputs = with pkgs; [
			pkg-config 
			libx11 
			libxcb
			libxcb-util
			libxcb-wm
			alsa-lib
		];
		
		src = pkgs.fetchFromGitHub {
			owner = "UtkarshVerma";
			repo = "dwmblocks-async";
			rev = "38cadc6427db51700b3add3c356da5d41b36f8e0";
			hash = "sha256-E3Jk+Cpcvo7/ePEdi09jInDB3JqLwN+ZHtutk3nmmhM=";
		};
		preBuild = ''cp ${configFile} config.h'';
	
		installPhase = ''
			make PREFIX=$out install
		'';		
	};
in
{
	options.programs.dwmblocks-async = {
		enable = mkEnableOption "dwmblocks-async";
		
		delimiter = {
			value = mkOption {
				type = types.str;
				default = "  ";
				description = "The string used to delimit blocks in the status";
			};
			leading = mkOption {
				type = types.bool;
				default = false;
				description = "Should a delimiter be prepended to the status?";
			};
			trailing = mkOption {
				type = types.bool;
				default = false;
				description = "Should a delimiter be appended to the status?";
			};
		};
		clickable_blocks = mkEnableOption "Toggle clickable blocks";
		max_block_length = mkOption {
			type = types.int;
			default = 45;
			description = "The maximum number of unicode characters that a block can output";
		};

		blocks = mkOption {
			type = types.listOf blockType;
			default = [];
			description = "The list of blocks to display (from left to right)";
		};
	};

	config = lib.mkIf cfg.enable {	
		# Mutally exclusive for all blocks
		# assertions = 
		# let
		# 	cmd_count =
		# 		(if config.command then 1 else 0) +
		# 		(if config.script then 1 else 0) +
		# 		(if config.script_raw then 1 else 0);
		# in
		# 	{
		# 		assertion = cmd_count;
		# 		message = "dwmblocks-async: You must specify EXACTLY ONE of 'command', 'script', or 'script_raw'.";
		# 	}
		# ];
		environment.systemPackages = [ dwmblocks-async ];
	};
}
