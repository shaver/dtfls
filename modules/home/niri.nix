{ inputs, ... }: {
  flake.modules.homeManager.niri = { config, pkgs, ... }:
    let configRepo = "${config.home.homeDirectory}/dtfls";
    in {
      home.packages = with pkgs; [ fuzzel swaylock waybar xwayland-satellite ];

      imports = [ inputs.self.modules.homeManager.alacritty ];

      services.swayidle = {
        enable = true;
        timeouts = [{
          command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
          resumeCommand = "${pkgs.niri}/bin/niri msg action power-on-monitors";
          timeout = 900; # 15 mins
        }];
      };

      # use the "raw" niri config from this repo
      xdg.configFile = {
        niri = {
          source =
            config.lib.file.mkOutOfStoreSymlink "${configRepo}/config/niri";
          recursive = true;
        };
      };

    };
}
