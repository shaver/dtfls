{ inputs, ... }:
{
  flake.modules.hjem.noctalia =
    {
      config,
      pkgs,
      ...
    }:
    let
      cursor = {
        name = "BreezeX-RosePine-Linux";
        package = pkgs.rose-pine-cursor;
        size = 24;
      };
    in
    {
      imports = [ inputs.noctalia.hjemModules.default ];

      packages = [
        pkgs.palenight-theme
        pkgs.adwaita-icon-theme
        cursor.package
      ];

      # gtk4 deliberately gets no theme name: Palenight is gtk3-only
      xdg.config.files = {
        "gtk-3.0/settings.ini".text = ''
          [Settings]
          gtk-application-prefer-dark-theme=1
          gtk-cursor-theme-name=${cursor.name}
          gtk-cursor-theme-size=${toString cursor.size}
          gtk-icon-theme-name=Adwaita
          gtk-theme-name=Palenight
        '';
        "gtk-4.0/settings.ini".text = ''
          [Settings]
          gtk-application-prefer-dark-theme=1
          gtk-cursor-theme-name=${cursor.name}
          gtk-cursor-theme-size=${toString cursor.size}
          gtk-icon-theme-name=Adwaita
        '';
      };
      files = {
        ".gtkrc-2.0".text = ''
          gtk-cursor-theme-name = "${cursor.name}"
          gtk-cursor-theme-size = ${toString cursor.size}
          gtk-icon-theme-name = "Adwaita"
          gtk-theme-name = "Palenight"
        '';
        ".icons/default/index.theme".text = ''
          [Icon Theme]
          Name=Default
          Comment=Default Cursor Theme
          Inherits=${cursor.name}
        '';
      };

      environment.sessionVariables = {
        GTK2_RC_FILES = "${config.directory}/.gtkrc-2.0";
        XCURSOR_THEME = cursor.name;
        XCURSOR_SIZE = toString cursor.size;
        QT_QPA_PLATFORMTHEME = "gtk3";
      };

      programs.noctalia = {
        enable = true;
      };

      xdg.config.files.noctalia.source = "${config.directory}/dtfls/config/noctalia";

      nix.settings = {
        extra-substituters = [
          "https://noctalia.cachix.org"
        ];
        extra-trusted-public-keys = [
          "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        ];
      };
    };

  flake.modules.nixos.noctalia-greeter = { pkgs, ... }: {
    services.displayManager.noctalia-greeter = {
      enable = true;
      settings = {
        cursor.size = 24;
        keyboard.layout = "us";
        output.layout = "DP-3:0,0; DP-2:3440,-400"; # TODO splashdown
        session.default = "Umbriel";
        idle.timeout = 300;
      };
      cursorTheme = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
      };
    };
  };
}
