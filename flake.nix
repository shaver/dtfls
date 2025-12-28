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
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      name = "splashdown";
    in
    {
      nixosConfigurations.${name} = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.shaver = import ./home.nix;
          }

          inputs.determinate.nixosModules.default

          ./configuration.nix # includes hardware-configuration.nix
        ];
      };

      formatter.${system} = inputs.nixpkgs.legacyPackages.${system}.nixfmt;
    };
}
