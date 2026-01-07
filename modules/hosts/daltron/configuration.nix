{ config, inputs, ... }:
{
  flake.modules.darwin.daltron =
    { pkgs, ... }:
    {
      imports = [
        inputs.determinate.darwinModules.default
      ]
      ++ (with config.flake.modules.darwin; [
        base-system
        shaver-personal
      ])
      ++ (with config.flake.commonModules; [ sudo ]);
    };
}
