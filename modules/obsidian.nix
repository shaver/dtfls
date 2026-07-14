{
  flake.modules.homeManager.obsidian = { pkgs, ... }: {
    home.packages = [ pkgs.obsidian ];
    # future: configure syncthing here
  };
}
