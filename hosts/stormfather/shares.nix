{ config, pkgs, ... }:
let
	vanasa = {
		uid = config.users.users.vanasa.uid;
		gid = config.users.users.vanasa.gid;
	};
	jellyfin = {
		uid = config.users.users.jellyfin.uid;
		gid = config.users.groups.jellyfin.gid;
	};
{
	services.nfs = {
		enable = true;
		# See https://wiki.archlinux.org/title/NFS#Server_configuration
		# See https://man.archlinux.org/man/exports.5
		#  - rw - Read/Write Perms
		#  - sync - Reply to requests only after changes are committed
		#  - no_subtree_check - Don't check the file is in an exported subtree
		# UID_MAPPING:
		#  - root_squash - map ONLY the root uid to anon id
		#  - no_root_squash - DO NOT map root (uid 0) to anon id
		#  - all_squash - map all uids to anon id
		#
		#  - anonuid - the user to map to based on the above rules
		#  - anongid - the user to map to based on the above rules
		exports = ''
			/mnt/vdev1/Media 10.0.0.99/32(rw,sync,no_subtree_check,all_squash,anonuid=${jellyfin.uid},anongid=${jellyfin.gid})
			/mnt/vdev1/Shared 10.0.0.99/32(rw,sync,no_subtree_check,all_squash,anonuid=${vanasa.uid},anongid=${vanasa.gid})
		'';
	};

	services.samba = {
		enable = true;
		settings."VaNASa" = {
			"path" =  "/mnt/vdev1/Shared";
			"browseable" = "yes";
			"read only" = "no";
			"guest ok" = "yes";
			"create mask" = "0644";
			"directory mask" = "0755";
			"force user" = "vanasa";
			"force group" = "vanasa";
		};
	};
}
