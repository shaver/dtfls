{
  flake.modules.hjem.obsidian = { pkgs, ... }: {
    packages = [ pkgs.obsidian ];
    # future: configure syncthing here
  };
}
