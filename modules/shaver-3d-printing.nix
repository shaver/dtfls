{
  flake.modules.homeManager.shaver-3d-printing = { pkgs, ... }: {
    home.packages = [ pkgs.prusa-slicer ];
  };
}
