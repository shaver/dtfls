{ inputs, ... }:
{
  flake.modules.nixos.gaming =
    { pkgs, ... }:
    let
      inherit (inputs.self.packages.${pkgs.stdenv.hostPlatform.system}) xlm;
    in
    {
      imports = with inputs.nix-gaming.nixosModules; [
        wine
        platformOptimizations
      ];

      # avoid having to build everything
      ## covered by ncro in nix.nix
      nix.settings = {
        extra-substituters = [ "https://nix-gaming.cachix.org" ];
        extra-trusted-public-keys = [
          "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        ];
      };

      programs.steam = {
        package = pkgs.steam.override {
          extraPkgs =
            pkgs': with pkgs'; [
              libXcursor
              libXi
              libXinerama
              libXScrnSaver
              libpng
              libpulseaudio
              libvorbis
              stdenv.cc.cc.lib # Provides libstdc++.so.6
              libkrb5
              keyutils
            ];
        };

        enable = true;
        remotePlay.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        gamescopeSession.enable = true;
        extraCompatPackages = [
          pkgs.proton-ge-bin
          inputs.proton-cachyos.packages.${pkgs.stdenv.hostPlatform.system}.proton-cachyos
          xlm
        ];
        extraPackages = [ pkgs.gamemode ];
        platformOptimizations.enable = true;
      };

      environment.systemPackages = [ pkgs.gamescope ];
      hardware.steam-hardware.enable = true;

      programs.wine = {
        enable = true;
        ntsync = true;
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
      home = {
        packages = [
          # pkgs.xivlauncher # now managed by xlm
          do-ff14-otp
        ];
        sessionVariables = {
          "__GL_SHADER_DISK_CACHE_SIZE" = "10737418240";
        };
      };
      xdg.desktopEntries.do-ff14-otp = {
        name = "FF14 OTP";
        exec = "${lib.getExe do-ff14-otp}";
        categories = [ "Game" ];
      };
    };
}
