{
  flake.modules.hjem.home-assistant =
    { pkgs, ... }:
    {
      packages = [ pkgs.home-assistant-cli ];
    };
}
