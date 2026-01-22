{ config, inputs, ... }:
{
  flake.modules.darwin.work-laptop =
    { pkgs, ... }:
    {
      imports = [
        inputs.determinate.darwinModules.default
      ]
      ++ (with config.flake.modules.darwin; [
        base-system
        shaver-work
      ])
      ++ (with config.flake.commonModules; [ sudo ]);
    };
}
