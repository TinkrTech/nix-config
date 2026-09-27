{ ... }:
{ 
	services.dunst = {
		enable = true;
		settings = {
			global = {
				font = "Droid Mono 14";
				corner_radius = 15;
			};
			
			urgency_normal = {
				background = "#37474f";
				foreground = "#eceff1";
				timeout = 10;
			};

			urgency_critical = {
				timeout = 30;
			};
		};
	};
	
}
