{ inputs, ... }:
{
  flake.modules.nixos.gaming =
    {
      pkgs,
      ...
    }:
    {
      imports = with inputs.nix-gaming.nixosModules; [
        wine
        platformOptimizations
      ];

      # avoid having to build everything
      nix.settings = {
        substituters = [ "https://nix-gaming.cachix.org" ];
        trusted-public-keys = [ "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
      };

      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        gamescopeSession.enable = true;
        extraCompatPackages = [ pkgs.proton-ge-bin ];
        extraPackages = [ pkgs.gamemode ];
        platformOptimizations.enable = true;
      };

      programs.wine = {
        enable = true;
        ntsync = true;
      };
    };
}
