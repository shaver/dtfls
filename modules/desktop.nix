{ inputs, ... }:
{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.jellyfin-desktop
        pkgs.wl-clipboard
      ];

      imports = [ inputs.self.modules.homeManager.alacritty ];
    };

  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
      };

      environment.systemPackages = [ pkgs.mate-polkit ];
      security.polkit.enable = true;

      programs.thunar = {
        enable = true;
        plugins = with pkgs; [
          thunar-volman
          thunar-shares-plugin
          thunar-archive-plugin
          thunar-dropbox-plugin
        ];
      };

      services.gvfs.enable = true;
      services.tumbler.enable = true;

      systemd = {
        user.services.polkit-mate-1 = {
          description = "MATE polkit agent";
          wantedBy = [ "graphical-session.target" ];
          wants = [ "graphical-session.target" ];
          after = [ "graphical-session.target" ];
          serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.mate-polkit}/libexec/polkit-mate-authentication-agent-1";
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
          };
        };
      };

      programs.niri.enable = true;

      # for printer discovery?
      services.avahi = {
        enable = true;
        openFirewall = true;
      };
    };
}
