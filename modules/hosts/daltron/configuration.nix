{ inputs, ... }:
{
  flake.modules.darwin.daltron = {
    imports = with inputs.self.modules.darwin; [
      shaver-personal
    ];
  };
}
