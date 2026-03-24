{ inputs, config, ... }:
let
  inherit (config) flake;
  inherit (inputs) nixpkgs;

  # build a nixosConfiguration for `hostname` running on `system`
  makeNixosConfiguration =
    hostname: system:
    (nixpkgs.lib.nixosSystem {

      modules = [
        flake.modules.nixos.${hostname}
        {
          networking.hostName = hostname;
        }
        flake.modules.nixos.base-system
      ];

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    });
in
{
  # these will live in modules/hosts/${hostname}/configuration.nix
  flake.nixosConfigurations = {
    splashdown = makeNixosConfiguration "splashdown" "x86_64-linux";
    outpost-arm64 = makeNixosConfiguration "outpost-arm64" "aarch64-linux";
  };

  flake.modules.homeManager.host-splashdown-shaver = { };
  flake.modules.homeManager.host-outpost-arm64-shaver = { };
}
