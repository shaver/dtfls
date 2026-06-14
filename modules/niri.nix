{ inputs, ... }:
{
  flake.modules.homeManager.niri =
    { config, pkgs, ... }:
    let
      configRepo = "${config.home.homeDirectory}/dtfls";
    in
    {
      home.packages = with pkgs; [
        fuzzel
        swaylock
        waybar
        xwayland-satellite
        playerctl
      ];

      # use the "raw" niri config from this repo
      xdg.configFile = {
        niri = {
          source = config.lib.file.mkOutOfStoreSymlink "${configRepo}/config/niri";
          recursive = true;
        };
      };

    };
}
