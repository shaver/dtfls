{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.mate.caja-with-extensions
        pkgs.jellyfin-desktop
        pkgs.wl-clipboard
      ];
    };
}
