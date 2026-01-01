{
  flake.modules.nixos.steam =
    {
      pkgs,
      ...
    }:
    {
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        gamescopeSession.enable = true;
        extraCompatPackages = [ pkgs.proton-ge-bin ];
        extraPackages = [ pkgs.gamemode ];
      };
    };
}
