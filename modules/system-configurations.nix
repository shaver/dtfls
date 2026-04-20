{
  inputs,
  config,
  lib,
  ...
}:
let
  inherit (config) flake;
  inherit (inputs) nixpkgs nix-darwin;
  inherit (lib) mapAttrs' nameValuePair;

  hostMap = {
    nixos = {
      splashdown = "x86_64-linux";
      "outpost-arm64" = "aarch64-linux";
    };
    darwin = {
      GWJ1G39KMF = "aarch64-darwin";
      daltron = "aarch64-darwin";
    };
  };

  builderForOS = os: (if os == "nixos" then nixpkgs.lib.nixosSystem else nix-darwin.lib.darwinSystem);

  # construct a basic system configuration
  makeConfiguration =
    hostname: system: os:
    (builderForOS os) {
      modules = [
        flake.modules.${os}.${hostname}
        { networking.hostName = hostname; }
        flake.modules.${os}.base-system
      ];

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    };

  # build all configurations and per-host HM module stubs for all hosts of the given os
  makeConfigurations = hostMap: os: {
    "${os}Configurations" = mapAttrs' (
      hostname: system: nameValuePair hostname (makeConfiguration hostname system os)
    ) hostMap.${os};
    modules.homeManager = mapAttrs' (
      hostname: _: nameValuePair "host-${hostname}-shaver" { }
    ) hostMap.${os};
  };

  nixosConfigurations = makeConfigurations hostMap "nixos";
  darwinConfigurations = makeConfigurations hostMap "darwin";
in
{
  flake = lib.recursiveUpdate nixosConfigurations darwinConfigurations;
}
