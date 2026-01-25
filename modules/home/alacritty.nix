{
  flake.modules.homeManager.alacritty = { config, pkgs, ... }:
    let configRepo = "${config.home.homeDirectory}/dtfls";
    in {
      home.packages = [ pkgs.alacritty ];
      xdg.configFile.alacritty = {
        source =
          config.lib.file.mkOutOfStoreSymlink "${configRepo}/config/alacritty";
        recursive = true;
      };
    };
}
