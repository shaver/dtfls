{
  flake.modules.nixos.desktop = { pkgs, ... }: {
    # Enable the KDE Plasma Desktop Environment.
    services = {
      displayManager.sddm = {
        enable = true;
        wayland.enable = true;
      };
      desktopManager.plasma6.enable = true;
    };

    environment.systemPackages = [ pkgs.mate.mate-polkit ];
    security.polkit.enable = true;

    systemd = {
      user.services.polkit-mate-1 = {
        description = "MATE polkit agent";
        wantedBy = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart =
            "${pkgs.mate.mate-polkit}/libexec/polkit-mate-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };

    programs.niri.enable = true;
  };
}
