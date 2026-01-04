{
  flake.modules.homeManager.niri =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        fuzzel
        alacritty
        hyprlock
        xwayland-satellite
      ];
    };
}
