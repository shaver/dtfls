{ inputs, ... }:
{
  flake.modules.darwin.alchemist =
    { pkgs, ... }:
    {
      imports = [ inputs.self.modules.darwin.shaver-work ];
    };
}
