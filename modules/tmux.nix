{
  flake.modules.hjem.tmux =
    { config, pkgs, ... }:
    let
      configRepo = "${config.directory}/dtfls";
    in
    {
      packages = [ pkgs.tmux ];
      xdg.config.files.tmux.source = "${configRepo}/config/tmux";
    };
}
