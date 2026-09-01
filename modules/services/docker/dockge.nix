{ config, pkgs, ... }:
let
	service_user = config.service-user;
	service_group = config.service-group;
	service_uid = toString config.users.users."${service_user}".uid;
	volumes = {
		data = "/var/lib/dockge";
		stacks = "/var/lib/dockge/stacks";
	};
in
{
	system.activationScripts.dockge-dirs = ''
		mkdir -p ${volumes.data} ${volumes.stacks}
		chown -R  ${service_user}:${service_group} ${volumes.data} ${volumes.stacks}
	'';
	systemd.user.tmpfiles.rules = [
		"d /var/lib/dockge 0750 ${service_user} ${service_group} -"
		"d /var/lib/dockge/stacks 0750 ${service_user} ${service_group} -"
	];

	virtualisation.oci-containers.containers.dockge = {
		image = "louislam/dockge:latest";
		autoStart = true;
		ports = [ "5001:5001" ];
		volumes = [
			"${volumes.data}:/app/data"
			"${volumes.stacks}:/opt/stacks"
			"/run/user/${service_uid}/docker.sock:/var/run/docker.sock"
		];
		environment = {
			DOCKER_RESTART_POLICY = "unless-stopped";
		};

		extraOptions = [
			"--user=${service_uid}:${service_uid}"
		];
	};

}
