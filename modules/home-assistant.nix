{
  flake.modules.homeManager.home-assistant =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.home-assistant-cli ];
    };
}
