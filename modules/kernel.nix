{ inputs, ... }:
{
  flake.modules.nixos.testing-kernel =
    { lib, ... }:
    let
      shaver-nixpkgs = import inputs.shaver-nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true; # should be in the NVIDIA thing but...
      };
    in
    {
      boot.kernelPackages = lib.mkForce shaver-nixpkgs.linuxPackages_testing;
    };
}
