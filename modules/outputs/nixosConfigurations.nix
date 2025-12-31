{
  inputs,
  config,
  ...
}:
let
  inherit (config) flake;
  inherit (inputs) nixpkgs;
in
{
  flake.nixosConfigurations = {
    # later, this will be a map that assembles all the hosts
    splashdown =
      let
        system = "x86_64-linux";
        hostname = "splashdown";
      in
      nixpkgs.lib.nixosSystem {
        # these will live in modules/hosts/${hostname}/configuration.nix
        modules = [ flake.modules.nixos.${hostname} ];
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      };
  };
}
