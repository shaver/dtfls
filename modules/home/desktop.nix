{
  flake.modules.homeManager.desktop = { pkgs, ... }: {
    home.packages = with pkgs; [ mate.caja-with-extensions jellyfin-desktop ];
  };
}
