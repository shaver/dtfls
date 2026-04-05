{ inputs, ... }:
{
  flake.modules.homeManager.noctalia =
    { config, pkgs, ... }:
    {
      imports = [ inputs.noctalia.homeModules.default ];

      gtk = {
        enable = true;
        theme = {
          name = "Tokyonight-Dark";
          package = pkgs.tokyonight-gtk-theme;
        };

        iconTheme = {
          name = "Adwaita";
          package = pkgs.adwaita-icon-theme;
        };

        gtk3.extraConfig = {
          "gtk-application-prefer-dark-theme" = 1;
        };

        gtk4.extraConfig = {
          "gtk-application-prefer-dark-theme" = 1;
        };
      };

      xdg.configFile."gtk-4.0/gtk.css".force = true;

      home.pointerCursor = {
        name = "BreezeX-RosePine-Linux";
        package = pkgs.rose-pine-cursor;
        size = 24;
        gtk.enable = true;
        x11.enable = true;
      };

      home.sessionVariables = {
        XCURSOR_THEME = "BreezeX-RosePine-Linux";
        XCURSOR_SIZE = "24";
        QT_QPA_PLATFORMTHEME = "gtk3";
      };

      programs.noctalia-shell = {
        enable = true;
      };

      xdg.configFile.noctalia = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dtfls/config/noctalia";
        recursive = true;
      };
    };
}
