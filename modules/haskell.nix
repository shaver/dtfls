{
  flake.modules.homeManager.haskell =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        ghc
        haskell-language-server
      ];
    };
}
