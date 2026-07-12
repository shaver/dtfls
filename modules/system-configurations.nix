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
      splashdown = {
        system = "x86_64-linux";
        pkgs = {
          config.cudaSupport = true;
        };
      };
      "outpost-arm64" = {
        system = "aarch64-linux";
      };
    };
    darwin = {
      alchemist = {
        system = "aarch64-darwin";
      };
      daltron = {
        system = "aarch64-darwin";
      };
    };
  };

  builderForOS = os: (if os == "nixos" then nixpkgs.lib.nixosSystem else nix-darwin.lib.darwinSystem);

  # construct a basic system configuration
  makeConfiguration =
    hostname: data: os:
    (builderForOS os) {
      modules = [
        flake.modules.${os}.${hostname}
        { networking.hostName = hostname; }
        flake.modules.${os}.base-system
        flake.modules.generic.dtfls
      ];

      # create our nixpkgs instance, overlaying any per-host options
      pkgs = import nixpkgs (
        lib.recursiveUpdate {
          inherit (data) system;
          config.allowUnfree = true;
        } (data.pkgs or { })
      );
    };

  # build all configurations and per-host HM module stubs for all hosts of the given os
  makeConfigurations = hostMap: os: {
    "${os}Configurations" = mapAttrs' (
      hostname: data: nameValuePair hostname (makeConfiguration hostname data os)
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
