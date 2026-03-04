{
  flake.modules.generic.nix =
    { pkgs, ... }:
    {
      nix.settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];

        trusted-users = [
          "root"
          "shaver"
          "@wheel"
        ];
      };

      environment.systemPackages = [ pkgs.rippkgs ];

      # detsys and nix-darwin don't get along
      # condition on detsys use? mkIf nix.package == blah blah
      nix.enable = !pkgs.stdenv.isDarwin;
    };
}
