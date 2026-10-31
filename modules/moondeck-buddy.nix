{ inputs, ... }:
{
  # MoonDeck Buddy as a systemd user unit, managed by hjem.
  # Only imported for x86_64-linux hosts: moondeck-buddy is the only
  # package built for that platform.
  flake.modules.hjem.moondeck-buddy =
    {
      pkgs,
      lib,
      ...
    }:
    let
      inherit (inputs.self.packages.${pkgs.stdenv.hostPlatform.system}) moondeck-buddy;
    in
    {
      packages = [ moondeck-buddy ];

      # based on the one by RoastBeefer00 at
      # https://github.com/RoastBeefer00/nixos-config/blob/3a3801b52aa18cc598a17eec05c6bba31cf8449e/hm_modules/moondeck-buddy.nix#L207
      systemd.services.moondeckbuddy-gui = {
        enable = true;
        unitConfig = {
          Description = "MoonDeck Buddy (GUI session)";
          After = [ "graphical-session.target" ];
          PartOf = [ "graphical-session.target" ];
        };

        serviceConfig = {
          Type = "simple";
          ExecStart = lib.getExe moondeck-buddy;
          Restart = "on-failure";
          RestartSec = "5s";
          Environment = [
            "XDG_CONFIG_HOME=%h/.config"
            "XDG_DATA_HOME=%h/.local/share"
          ];
        };

        wantedBy = [ "graphical-session.target" ];
      };
    };
}