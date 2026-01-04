{ inputs, ... }:
{
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
