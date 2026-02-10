{ inputs, ... }:
{
  flake.modules.darwin.daltron = {
    imports = with inputs.self.modules.darwin; [
      base-system
      shaver-personal
    ];
  };
}
