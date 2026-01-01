{ inputs, ... }:
{
  flake.modules.nixos.shaver = {
    imports = [ inputs.home-manager.nixosModules.home-manager ];
    config.home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.shaver = import ./_home.nix;
    };
  };
}
