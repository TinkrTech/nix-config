{ config, pkgs, ... }:
let
	docker_uid = toString config.users.users.docker.uid;
	volumes = {
		data = "/var/lib/dockge";
		stacks = "/var/lib/dockge/stacks";
	};
in
{
	system.activationScripts.dockge-dirs = ''
		mkdir -p ${volumes.data} ${volumes.stacks}
		chown -R docker:docker ${volumes.data} ${volumes.stacks}
	'';
	systemd.user.tmpfiles.rules = [
		"d /var/lib/dockge 0750 docker docker -"
		"d /var/lib/dockge/stacks 0750 docker docker -"
	];

	virtualisation.oci-containers.containers.dockge = {
		image = "louislam/dockge:latest";
		autoStart = true;
		ports = [ "5001:5001" ];
		volumes = [
			"${volumes.data}:/app/data"
			"${volumes.stacks}:/opt/stacks"
			"/run/user/${docker_uid}/docker.sock:/var/run/docker.sock"
		];
		environment = {
			DOCKER_RESTART_POLICY = "unless-stopped";
		};

		extraOptions = [
			"--user=${docker_uid}:${docker_uid}"
		];
	};

}
