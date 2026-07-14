{ inputs, ... }:
{
  flake.modules.generic.nix =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      nix = {
        optimise.automatic = config.nix.enable;
        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];

          trusted-users = [
            "shaver"
            "@wheel"
          ];

          # ideally this would be in the noctalia module, but that's a home-manager
          # module and can't affect global nix settings
          extra-substituters = [ "https://noctalia.cachix.org" ];
          extra-trusted-public-keys = [
            "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
          ];

          warn-dirty = false;

          # ensure that the registry only contains our inputs
          nix-path = lib.mapAttrsToList (n: _: "${n}=flake:${n}") inputs;
          flake-registry = "";

          # download-buffer-size = 671088640; # 640MB or 10x the default. lfg
        };
      };

      environment.systemPackages = [ pkgs.rippkgs ];
    };
}
