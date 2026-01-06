{
  inputs,
  config,
  ...
}:
let
  inherit (config) flake;
  inherit (inputs) nix-darwin nixpkgs;
  work-laptop = nix-darwin.lib.darwinSystem {
    # these will live in modules/hosts/${hostname}/configuration.nix
    modules = [ flake.modules.darwin.work-laptop ];
    pkgs = import nixpkgs {
      system = "aarch64-darwin";
      config.allowUnfree = true;
    };
  };
in
{
  flake.darwinConfigurations = {
    # later, this will be a map that assembles all the hosts
    GWJ1G39KMF = work-laptop;
    inherit work-laptop;
  };
}
