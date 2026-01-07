{ inputs, ... }:
{
  flake.modules.homeManager.shaver-personal-darwin =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        shaver-personal
      ];
      home.packages = with pkgs; [
        less
        coreutils
      ];
    };
  flake.modules.homeManager.shaver-personal-nixos =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        shaver-personal
        niri
      ];
      home.packages = with pkgs; [
        signal-desktop
      ];
    };
  flake.modules.homeManager.shaver-personal =
    {
      flake,
      pkgs,
      config,
      ...
    }:
    {
      imports = [
        inputs.self.modules.homeManager.shaver-base
      ]
      ++ (with inputs.self.modules.homeManager; [
        irssi
      ]);
    };
}
