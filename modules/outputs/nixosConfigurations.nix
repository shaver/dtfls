{ inputs, config, ... }:
let
  inherit (config) flake;
  inherit (inputs) nixpkgs;
  outpost-arm64-attrs = {
    modules = [
      flake.modules.nixos.outpost-arm64
      { networking.hostName = "outpost-arm64"; }
    ];

    pkgs = import nixpkgs {
      system = "aarch64-linux";
      config.allowUnfree = true;
    };
  };
in {
  flake.nixosConfigurations = {
    # later, this will be a map that assembles all the hosts
    splashdown = nixpkgs.lib.nixosSystem {
      # these will live in modules/hosts/${hostname}/configuration.nix
      modules = [
        flake.modules.nixos.splashdown
        { networking.hostName = "splashdown"; }
      ];
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
    };

    outpost-arm64 = nixpkgs.lib.nixosSystem outpost-arm64-attrs;
    outpost-arm64_cross-x86_64 = nixpkgs.lib.nixosSystem (outpost-arm64-attrs
      // {
        modules = [
          flake.modules.nixos.outpost-arm64
          {
            networking.hostName = "outpost-arm64";
            nixpkgs.buildPlatform.system = "x86_64-linux";
          }
        ];
      });
  };
}
