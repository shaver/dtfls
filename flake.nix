{
  description = "splashdown system-wide flake";

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
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-parts,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      inherit (nixpkgs.lib.fileset) toList fileFilter;
      mkImport =
        path: toList (fileFilter (file: file.hasExt "nix" && !(nixpkgs.lib.hasPrefix "_" file.name)) path);
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      imports = [
        flake-parts.flakeModules.modules
      ]
      ++ (mkImport ./modules);

      flake = {
        formatter.${system} = inputs.nixpkgs.legacyPackages.${system}.nixfmt;
      };
    };
}
