{
  flake.modules.homeManager.claude-code =
    { pkgs, ... }:
    {
      # hit the cache
      nix.settings = {
        substituters = [ "https://claude-code.cachix.org" ];
        trusted-public-keys = [ "claude-code.cachix.org-1:YeXf2aNu7UTX8Vwrze0za1WEDS+4DuI2kVeWEE4fsRk=" ];
      };

      home.packages = [ pkgs.claude-code ];
    };
}
