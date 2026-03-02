{ inputs, config, ... }:
let
  inherit (config) flake;
  inherit (inputs) nixpkgs nixpkgs-patcher;
  buildSystems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];

  # build a nixosConfiguration for `hostname` running on `system` that's
  # built by `buildSystem`
  makeNixosConfiguration = hostname: system: buildSystem:
    (nixpkgs-patcher.lib.nixosSystem {
      nixpkgsPatcher.inputs = inputs;

      modules = [
        flake.modules.nixos.${hostname}
        {
          networking.hostName = hostname;
          nixpkgs.buildPlatform.system = buildSystem;
        }
      ];

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    });

  # generate a set of configurations for building `hostname` (running
  # `system`) for each compilation system
  forEachOtherBuildSystem = system: f:
    (map f (builtins.filter (sys: sys != system) buildSystems));
  nixosConfigurationsFor = hostname: system:
    (builtins.listToAttrs (forEachOtherBuildSystem system (buildSystem: {
      name = "${hostname}_${buildSystem}";
      value = makeNixosConfiguration hostname system buildSystem;
    }))) // {
      ${hostname} = makeNixosConfiguration hostname system system;
    };
in {
  # these will live in modules/hosts/${hostname}/configuration.nix
  flake.nixosConfigurations =
    (nixosConfigurationsFor "splashdown" "x86_64-linux")
    // (nixosConfigurationsFor "outpost-arm64" "aarch64-linux");
}
