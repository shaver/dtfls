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
      ])
      ++ (with config.flake.commonModules; [ sudo ]);
    };
}
