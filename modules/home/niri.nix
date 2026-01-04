{
  flake.modules.homeManager.niri =
    { pkgs, config, ... }:
    let
      configRepo = "${config.home.homeDirectory}/dtfls";
    in
    {
      home.packages = with pkgs; [
        fuzzel
        alacritty
        hyprlock
        waybar
        xwayland-satellite
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
