{ inputs, ... }:
{
  flake.modules.hjem.niri =
    { config, pkgs, ... }:
    let
      configRepo = "${config.directory}/dtfls";
    in
    {
      packages = with pkgs; [
        fuzzel
        swaylock
        waybar
        xwayland-satellite
        playerctl
      ];

      # use the "raw" niri config from this repo
      xdg.config.files.niri.source = "${configRepo}/config/niri";
    };

  flake.modules.nixos.niri = {
    programs.niri.enable = true;
  };
}
