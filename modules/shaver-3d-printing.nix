{
  flake.modules.hjem.shaver-3d-printing =
    { pkgs, ... }:
    {
      packages = [
        pkgs.prusa-slicer
        pkgs.orca-slicer
      ];
    };
}
