{ inputs, ... }:
{
  flake.modules.homeManager.claude-code =
    { pkgs, ... }:
    {
      # hit the cache
      nix.settings = {
        extra-substituters = [ "https://claude-code.cachix.org" ];
        extra-trusted-public-keys = [
          "claude-code.cachix.org-1:YeXf2aNu7UTX8Vwrze0za1WEDS+4DuI2kVeWEE4fsRk="
        ];
      };

      home.packages = [
        inputs.claude-code.packages.${pkgs.stdenv.hostPlatform.system}.claude-code
      ];
    };
}
