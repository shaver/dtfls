{
  inputs,
  config,
  ...
}:
let
  inherit (config) flake;
  inherit (inputs) nix-darwin nixpkgs;

  makeDarwinConfiguration =
    hostname:
    (nix-darwin.lib.darwinSystem {
      modules = [
        flake.modules.darwin.${hostname}
        flake.modules.darwin.base-system
        {
          networking.hostName = hostname;
        }
      ];

      pkgs = import nixpkgs {
        system = "aarch64-darwin";
        config.allowUnfree = true;
      };
    });
in
{
  flake.darwinConfigurations = {
    GWJ1G39KMF = makeDarwinConfiguration "GWJ1G39KMF";
    daltron = makeDarwinConfiguration "daltron";
  };
}
