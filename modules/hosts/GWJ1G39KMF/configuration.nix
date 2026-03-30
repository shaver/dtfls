{ inputs, ... }:
{
  flake.modules.darwin.GWJ1G39KMF =
    { pkgs, ... }:
    {
      imports = [ inputs.self.modules.darwin.shaver-work ];
    };
}
