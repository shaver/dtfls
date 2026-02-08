{
  flake.modules.homeManager.tmux = { config, pkgs, ... }:
    let configRepo = "${config.home.homeDirectory}/dtfls";
    in {
      home.packages = [ pkgs.tmux ];
      xdg.configFile.tmux = {
        source =
          config.lib.file.mkOutOfStoreSymlink "${configRepo}/config/tmux";
        recursive = true;
      };
    };
}
