{
  description = "dtfls comprehensive and brilliant flake";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    determinate = {
      url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-parts, ... }@inputs:
    let
      systems = [ "x86_64-linux" "aarch64-darwin" "aarch64-linux" ];

      inherit (nixpkgs.lib.fileset) toList fileFilter;
      inherit (nixpkgs.lib) lists hasPrefix;
      mkImport = path:
        toList
        (fileFilter (file: file.hasExt "nix" && !(hasPrefix "_" file.name))
          path);
    in flake-parts.lib.mkFlake { inherit inputs; } {
      inherit systems;

      imports = lists.flatten [
        flake-parts.flakeModules.modules
        (mkImport ./modules)
        (mkImport ./packages)
      ];

      # build formatters for each system
      flake.formatter = builtins.listToAttrs (map (system: {
        name = system;
        value = inputs.nixpkgs.legacyPackages.${system}.nixfmt;
      }) systems);
    };
}
