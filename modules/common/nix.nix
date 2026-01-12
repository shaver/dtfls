{
  flake.commonModules.nix =
    { pkgs, ... }:
    {
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      environment.systemPackages = [
        pkgs.rippkgs
      ];

      # condition on detsys use? mkIf nix.package == blah blah
      nix.enable = false; # let detsys manage it
    };
}
