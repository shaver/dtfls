{
  flake.modules.homeManager.music = { pkgs, ... }: {
    home.packages = [ pkgs.cider-2 ];
  };
}
