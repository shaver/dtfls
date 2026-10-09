{
  flake.modules.hjem.music =
    { pkgs, ... }:
    {
      packages = [ pkgs.cider-2 ];
    };
}
