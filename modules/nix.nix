{ inputs, ... }:
{
  flake.modules.generic.nix =
    { pkgs, lib, ... }:
    {
      nix = {
        optimise.automatic = true;
        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];

          trusted-users = [
            "shaver"
            "@wheel"
          ];

          warn-dirty = false;

          # ensure that the registry only contains our inputs
          nix-path = lib.mapAttrsToList (n: _: "${n}=flake:${n}") inputs;
          flake-registry = "";
        };
      };

      environment.systemPackages = [ pkgs.rippkgs ];

      # detsys and nix-darwin don't get along
      # condition on detsys use? mkIf nix.package == blah blah
      nix.enable = !pkgs.stdenv.isDarwin;
    };
}
