{ inputs, ... }:
{
  flake.modules.homeManager.noctalia =
    {
      config,
      pkgs,
      ...
    }:
    {
      imports = [ inputs.noctalia.homeModules.default ];

      gtk = {
        enable = true;
        theme = {
          name = "Palenight";
          package = pkgs.palenight-theme;
        };

        iconTheme = {
          name = "Adwaita";
          package = pkgs.adwaita-icon-theme;
        };

        gtk3.extraConfig = {
          "gtk-application-prefer-dark-theme" = 1;
        };

        gtk4 = {
          theme = null;
          extraConfig = {
            "gtk-application-prefer-dark-theme" = 1;
          };
        };
      };

      home.pointerCursor = {
        enable = true;
        name = "BreezeX-RosePine-Linux";
        package = pkgs.rose-pine-cursor;
        size = 24;
        gtk.enable = true;
      };

      home.sessionVariables = {
        XCURSOR_THEME = "BreezeX-RosePine-Linux";
        XCURSOR_SIZE = "24";
        QT_QPA_PLATFORMTHEME = "gtk3";
      };

      programs.noctalia = {
        enable = true;
      };

      xdg.configFile.noctalia = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dtfls/config/noctalia";
        recursive = true;
      };

      nix.settings = {
        extra-substituters = [
          "https://noctalia.cachix.org"
        ];
        extra-trusted-public-keys = [
          "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        ];
      };
    };
}
