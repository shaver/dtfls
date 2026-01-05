{
  flake.modules.homeManager.gaming =
    { pkgs, inputs, ... }:
    {
      home.packages = with inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}; [

      ];
    };
}
