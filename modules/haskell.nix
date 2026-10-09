{
  flake.modules.hjem.haskell =
    { pkgs, ... }:
    {
      packages = with pkgs; [
        ghc
        haskell-language-server
      ];
    };
}
