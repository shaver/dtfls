{
  inputs,
  config,
  ...
}:
let
  inherit (config) flake;
  inherit (inputs) nixpkgs;
  buildSystems = [
    "x86_64-linux"
    "aarch64-linux"
    "aarch64-darwin"
  ];

  # build a nixosConfiguration for `hostname` running on `system` that's
  # built by `buildSystem`
  makeNixosConfiguration = hostname: system: buildSystem: {
    "${hostname}_${buildSystem}" = nixpkgs.lib.nixosSystem {
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
    };
  };

  # generate a set of configurations for building `hostname` (running
  # `system`) for each compilation system
  forEachBuildSystem = f: (map f buildSystems);
  nixosConfigurationsFor =
    hostname: system:
    builtins.listToAttrs (
      forEachBuildSystem (buildSystem: {
        name = "${hostname}_${buildSystem}";
        value = makeNixosConfiguration hostname system buildSystem;
      })
    );
in
{
  # these will live in modules/hosts/${hostname}/configuration.nix
  flake.nixosConfigurations = {
    splashdown = makeNixosConfiguration "splashdown" "x86_64-linux" "x86_64-linux";
  }
  // (nixosConfigurationsFor "outpost-arm64" "aarch64-linux");
}
