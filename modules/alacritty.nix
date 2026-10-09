{
  flake.modules.hjem.alacritty =
    { config, pkgs, ... }:
    let
      configRepo = "${config.directory}/dtfls";
    in
    {
      packages = [ pkgs.alacritty ];
      # a string (not a nix path) source links straight into the repo
      xdg.config.files.alacritty.source = "${configRepo}/config/alacritty";
    };
}
