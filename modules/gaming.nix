{ inputs, ... }:
{
  flake.modules.nixos.gaming =
    { pkgs, ... }:
    let
      inherit (inputs.self.packages.${pkgs.stdenv.hostPlatform.system}) xlm;
    in
    {
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        gamescopeSession.enable = true;
        extraCompatPackages = [
          pkgs.proton-ge-bin
          xlm
        ];
        extraPackages = [ pkgs.gamemode ];
      };
    };

  flake.modules.homeManager.gaming =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      do-ff14-otp = pkgs.writeShellApplication {
        name = "do-ff14-otp";
        text = ''
          for i in $(seq 1 60); do
            TOTP=$(${lib.getExe' pkgs.oath-toolkit "oathtool"} --totp -b - < ${config.sops.secrets.ffxiv-otp-secret.path})
            if ${lib.getExe pkgs.curl} -sf "http://localhost:4646/ffxivlauncher/''${TOTP}"; then
              echo "succeeded with TOTP ''${TOTP} on attempt ''${i}"
              exit 0
            fi
            echo "failed with TOTP ''${TOTP} on attempt ''${i}"
            sleep 1
          done
          echo "failed to send TOTP"
          exit 1
        '';
      };
    in
    {
      home.packages = [
        pkgs.xivlauncher
        do-ff14-otp
      ];
      xdg.desktopEntries.do-ff14-otp = {
        name = "FF14 OTP";
        exec = "${lib.getExe do-ff14-otp}";
        categories = [ "Game" ];
      };
    };
}
